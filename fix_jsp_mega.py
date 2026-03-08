import os

path = r"c:\Users\dasun\eclipse-workspace\OceanView\OceanView\src\main\webapp\dashboard.jsp"

try:
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    print(f"Read {len(lines)} lines.")

    # --- FIX 1: STATUS BADGES (around line 450) ---
    start_status = -1
    end_status = -1
    
    # Locate the start of the status loop
    for i, line in enumerate(lines):
        if "<tbody>" in line and i > 400:
             # Look forward for the status logic
             for j in range(i, i+100):
                 if "String status" in lines[j] and "reservations" in lines[j-1]: # heuristic
                     start_status = j-1
                     break
                 if "for" in lines[j] and "Reservation r" in lines[j] and "reservations" in lines[j]:
                     start_status = j
                     break
             if start_status != -1:
                 # Find end of this block
                 for k in range(start_status, start_status+50):
                      if "%>" in lines[k] and "<tr>" in lines[k+1]:
                          end_status = k
                          break
                 break
    
    if start_status != -1 and end_status != -1:
        print(f"Replacing Status Logic: lines {start_status+1} to {end_status+1}")
        new_status_content = [
            '                                                                                <% for (Reservation r : reservations) {\n',
            '                                                                                    String status = r.getStatus();\n',
            '                                                                                    String badge = "bg-warning text-dark";\n',
            '                                                                                    if ("Confirmed".equals(status)) {\n',
            '                                                                                        badge = "bg-success";\n',
            '                                                                                    } else if ("Cancelled".equals(status)) {\n',
            '                                                                                        badge = "bg-danger";\n',
            '                                                                                    } else if ("Checked In".equals(status)) {\n',
            '                                                                                        badge = "bg-info text-dark";\n',
            '                                                                                    } else if ("Checked Out".equals(status)) {\n',
            '                                                                                        badge = "bg-secondary";\n',
            '                                                                                    }\n',
            '                                                                                %>\n'
        ]
        # We need to be careful not to mess up indices for the next fix.
        # But we can just replace in place in the list.
        # lines[start_status:end_status+1] = new_status_content 
        # Wait, modifying the list invalidates indices for the second search if we use absolute indices.
        # Better to do second search now.
    else:
        print("Could not find Status Logic block.")

    # --- FIX 2: ACTIONS COLUMN (around line 520) ---
    start_actions = -1
    end_actions = -1
    
    # Search for checkIn button which is unique
    for i, line in enumerate(lines):
        if 'value="checkIn"' in line and i > 500:
             # This is inside the confirmed block. 
             # Let's find the START of the whole logic.
             # It acts on "Pending" first usually? or "Confirmed"?
             # In the broken file:
             # 530: ("Pending".equals(status))
             # ...
             # 549: ("Confirmed".equals(status))
             
             # Let's look for the start of the cell logic.
             # It starts after the "Change Room" button (fa-bed).
             # Search backwards for "Change Room" or "fa-bed"
             for j in range(i, i-100, -1):
                 if "fa-bed" in lines[j] or "Change Room" in lines[j]:
                      # The logic starts shortly after closing the button
                      # lines[j+X] might be the start.
                      # Let's look for <% if
                      for k in range(j, i):
                          if "<%" in lines[k] and "if" in lines[k]:
                              start_actions = k
                              break
                      break
             
             if start_actions != -1:
                 # Find the end: </form>
                 for k in range(i, i+100):
                      if "</form>" in lines[k]:
                          end_actions = k - 1
                          break
             break
             
    if start_actions != -1 and end_actions != -1:
        print(f"Fixing Actions Logic: lines {start_actions+1} to {end_actions+1}")
    else:
        print("Could not find Actions Logic block.")


    # APPLY CHANGES (Actions first because it's further down, so it won't affect Status indices?
    # Actually if we use list slicing, we should do from bottom up.
    
    if start_actions != -1 and end_actions != -1:
        new_actions_content = [
            '<% if ("Pending".equals(status)) { %>\n',
            '    <button type="submit" name="action" value="confirm" class="btn btn-sm btn-success" title="Confirm">\n',
            '        <i class="fa-solid fa-check"></i>\n',
            '    </button>\n',
            '    <button type="submit" name="action" value="cancel" class="btn btn-sm btn-danger" title="Cancel">\n',
            '        <i class="fa-solid fa-xmark"></i>\n',
            '    </button>\n',
            '<% } else if ("Confirmed".equals(status)) { %>\n',
            '    <button type="submit" name="action" value="checkIn" class="btn btn-sm btn-info" title="Check In">\n',
            '        <i class="fa-solid fa-arrow-right-to-bracket"></i>\n',
            '    </button>\n',
            '    <button type="submit" name="action" value="cancel" class="btn btn-sm btn-danger" title="Cancel">\n',
            '        <i class="fa-solid fa-xmark"></i>\n',
            '    </button>\n',
            '<% } else if ("Checked In".equals(status)) { %>\n',
            '    <button type="button" class="btn btn-sm btn-primary" onclick="openCheckoutModal(<%= r.getReservationId() %>)" title="Check Out">\n',
            '        <i class="fa-solid fa-arrow-right-from-bracket"></i>\n',
            '    </button>\n',
            '<% } %>\n'
        ]
        lines[start_actions:end_actions+1] = new_actions_content
        print("Applied Actions fix.")
        
    if start_status != -1 and end_status != -1:
        # Since we modified lines below, the indices for status (which is above) should be fine?
        # UNLESS lines were deleted/inserted differently.
        # But `lines` object was modified in place. 
        # Wait, `lines[start:end] = new` changes the length of the list.
        # So `start_status` is still valid (it's earlier), but `end_status` might be valid too since it's earlier.
        # Yes, as long as we modify the later part first.
        lines[start_status:end_status+1] = new_status_content
        print("Applied Status fix.")

    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    print("Saved file.")

except Exception as e:
    print(f"Error: {e}")
