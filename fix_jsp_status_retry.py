import os

path = r"c:\Users\dasun\eclipse-workspace\OceanView\OceanView\src\main\webapp\dashboard.jsp"

try:
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    start_status = -1
    end_status = -1
    
    # Strategy: Find <tbody>. The next <% ... %> block is the loop with status logic.
    for i, line in enumerate(lines):
        if "<tbody>" in line and i > 400:
             print(f"Found <tbody> at line {i+1}")
             # Look forward for the start of the loop
             for j in range(i, i+20):
                 if "<%" in lines[j] and "for" in lines[j] and "Reservation" in lines[j+1]: # heuristic for split line
                     start_status = j
                     print(f"Found start at line {j+1}")
                     break
                 if "<%" in lines[j] and "for" in lines[j]: # simpler
                     start_status = j
                     print(f"Found start at line {j+1}")
                     break
                 if "for" in lines[j] and "Reservation" in lines[j]: # split <% \n for
                      start_status = j-1 # assuming <% is previous
                      print(f"Found start at line {j}")
                      break
             
             if start_status != -1:
                 # Find end: %> followed by <tr>
                 for k in range(start_status, start_status+100):
                      if "%>" in lines[k]:
                          # Check next non-empty line for <tr>
                          # But let's just assume the block ends at %>
                          end_status = k
                          print(f"Found end at line {k+1}")
                          break
                 break

    if start_status != -1 and end_status != -1:
        print(f"Replacing lines {start_status+1} to {end_status+1}")
        
        # New clean content
        new_content = [
            '<% for (Reservation r : reservations) {\n',
            '    String status = r.getStatus();\n',
            '    String badge = "bg-warning text-dark";\n',
            '    if ("Confirmed".equals(status)) {\n',
            '        badge = "bg-success";\n',
            '    } else if ("Cancelled".equals(status)) {\n',
            '        badge = "bg-danger";\n',
            '    } else if ("Checked In".equals(status)) {\n',
            '        badge = "bg-info text-dark";\n',
            '    } else if ("Checked Out".equals(status)) {\n',
            '        badge = "bg-secondary";\n',
            '    }\n',
            '%>\n'
        ]
        
        lines[start_status:end_status+1] = new_content
        
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(lines)
        print("Successfully replaced Status logic.")
    else:
        print("Could not locate Status logic block.")
        # Debug: check what's after <tbody>
        for i, line in enumerate(lines):
             if "<tbody>" in line:
                  print("DEBUG: lines after tbody:")
                  for k in range(1, 10):
                       print(f"{i+1+k}: {lines[i+k].strip()}")
                  break

except Exception as e:
    print(f"Error: {e}")
