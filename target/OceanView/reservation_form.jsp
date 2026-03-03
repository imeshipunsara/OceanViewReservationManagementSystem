<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null) { response.sendRedirect("login.jsp"); return;
            } %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>New Reservation - Ocean View Resort</title>
                <link rel="stylesheet" href="css/style.css">
            </head>

            <body>
                <div class="container">
                    <header style="margin-bottom: 2rem;">
                        <h1>Create Reservation</h1>
                        <a href="dashboard.jsp" class="btn">Back to Dashboard</a>
                    </header>

                    <div class="card">
                        <% String error=(String) request.getAttribute("errorMessage"); if (error !=null) { %>
                            <div class="alert">
                                <%= error %>
                            </div>
                            <% } %>

                                <form action="reservation" method="post" id="reservationForm">

                                    <!-- Guest Section -->
                                    <div class="card"
                                        style="box-shadow: none; border: 1px solid #eee; margin-bottom: 20px;">
                                        <h3>Guest Details</h3>

                                        <!-- Hidden field to store selected Guest ID -->
                                        <input type="hidden" id="selectedGuestId" name="guestId" required>

                                        <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                                            <button type="button" class="btn" onclick="showTab('search')" id="btnSearch"
                                                style="background-color: #3498db;">Search Existing</button>
                                            <button type="button" class="btn" onclick="showTab('new')" id="btnNew"
                                                style="background-color: #95a5a6;">New Guest</button>
                                        </div>

                                        <!-- Tab 1: Search -->
                                        <div id="searchGuestSection">
                                            <div class="form-group">
                                                <label for="searchQuery">Search by Email or Contact Number</label>
                                                <div style="display: flex; gap: 10px;">
                                                    <input type="text" id="searchQuery"
                                                        placeholder="Enter email or phone">
                                                    <button type="button" class="btn" onclick="searchGuest()"
                                                        style="margin-top: 0;">Search</button>
                                                </div>
                                                <p id="searchResult" style="margin-top: 10px; font-weight: bold;"></p>
                                            </div>
                                        </div>

                                        <!-- Tab 2: New Guest -->
                                        <div id="newGuestSection" style="display: none;">
                                            <div class="form-group">
                                                <label for="newGuestName">Full Name</label>
                                                <input type="text" id="newGuestName">
                                            </div>
                                            <div class="form-group">
                                                <label for="newGuestAddress">Address</label>
                                                <input type="text" id="newGuestAddress">
                                            </div>
                                            <div class="form-group">
                                                <label for="newGuestContact">Contact Number</label>
                                                <input type="text" id="newGuestContact">
                                            </div>
                                            <div class="form-group">
                                                <label for="newGuestEmail">Email</label>
                                                <input type="email" id="newGuestEmail">
                                            </div>
                                            <button type="button" class="btn" onclick="createNewGuest()">Create & Select
                                                Guest</button>
                                            <p id="createResult" style="margin-top: 10px; font-weight: bold;"></p>
                                        </div>

                                        <!-- Selected Guest Display -->
                                        <div id="selectedGuestDisplay"
                                            style="background-color: #d4edda; padding: 10px; border-radius: 4px; display: none; margin-top: 15px;">
                                            Selected Guest: <span id="displayGuestName"></span> (ID: <span
                                                id="displayGuestId"></span>)
                                            <button type="button"
                                                style="background: none; border: none; color: red; cursor: pointer; margin-left: 10px;"
                                                onclick="clearSelection()">Change</button>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label>Date Selection (Select dates to see available rooms)</label>
                                        <div style="display: flex; gap: 10px;">
                                            <div style="flex: 1;">
                                                <label for="checkInDate" style="font-size: 0.9em;">Check-In</label>
                                                <input type="date" id="checkInDate" name="checkInDate" required
                                                    onchange="checkAvailability()">
                                            </div>
                                            <div style="flex: 1;">
                                                <label for="checkOutDate" style="font-size: 0.9em;">Check-Out</label>
                                                <input type="date" id="checkOutDate" name="checkOutDate" required
                                                    onchange="checkAvailability()">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="roomId">Room</label>
                                        <select id="roomId" name="roomId" required disabled>
                                            <option value="">Select Dates First</option>
                                        </select>
                                        <span id="loadingRooms"
                                            style="display: none; color: #666; font-size: 0.9em;">Checking
                                            availability...</span>
                                    </div>

                                    <button type="submit" class="btn">Create Reservation</button>
                                </form>

                    </div>
                </div>

                <script>
                    function showTab(tab) {
                        document.getElementById('searchGuestSection').style.display = tab === 'search' ? 'block' : 'none';
                        document.getElementById('newGuestSection').style.display = tab === 'new' ? 'block' : 'none';

                        document.getElementById('btnSearch').style.backgroundColor = tab === 'search' ? '#3498db' : '#95a5a6';
                        document.getElementById('btnNew').style.backgroundColor = tab === 'new' ? '#3498db' : '#95a5a6';
                    }

                    function searchGuest() {
                        const query = document.getElementById('searchQuery').value;
                        if (!query) return;

                        fetch('GuestController?action=search&query=' + encodeURIComponent(query))
                            .then(response => response.json())
                            .then(data => {
                                const resultDisplay = document.getElementById('searchResult');
                                if (data.success) {
                                    resultDisplay.innerHTML = `<span style="color: green;">Found: ${data.name} (${data.email})</span> <button type="button" class="btn" onclick="selectGuest(${data.guestId}, '${data.name}')" style="margin-left: 10px; padding: 2px 8px; font-size: 0.8rem;">Select</button>`;
                                } else {
                                    resultDisplay.innerHTML = '<span style="color: red;">Guest not found.</span> <button type="button" class="btn" onclick="showTab(\'new\')" style="margin-left: 10px; padding: 2px 8px; font-size: 0.8rem; background-color: #e67e22;">Add New</button>';
                                }
                            })
                            .catch(error => console.error('Error:', error));
                    }

                    function createNewGuest() {
                        const formData = new URLSearchParams();
                        formData.append('action', 'add');
                        formData.append('guestName', document.getElementById('newGuestName').value);
                        formData.append('address', document.getElementById('newGuestAddress').value);
                        formData.append('contactNumber', document.getElementById('newGuestContact').value);
                        formData.append('email', document.getElementById('newGuestEmail').value);

                        fetch('GuestController', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => response.json())
                            .then(data => {
                                const resultDisplay = document.getElementById('createResult');
                                if (data.success) {
                                    selectGuest(data.guestId, data.name);
                                    resultDisplay.innerHTML = '<span style="color: green;">Guest created successfully!</span>';
                                } else {
                                    resultDisplay.innerHTML = `<span style="color: red;">Error: ${data.message}</span>`;
                                }
                            })
                            .catch(error => console.error('Error:', error));
                    }

                    function selectGuest(id, name) {
                        document.getElementById('selectedGuestId').value = id;
                        document.getElementById('displayGuestName').innerText = name;
                        document.getElementById('displayGuestId').innerText = id;
                        document.getElementById('selectedGuestDisplay').style.display = 'block';
                    }

                    function clearSelection() {
                        document.getElementById('selectedGuestId').value = '';
                        document.getElementById('selectedGuestDisplay').style.display = 'none';
                    }

                    function checkAvailability() {
                        const checkIn = document.getElementById('checkInDate').value;
                        const checkOut = document.getElementById('checkOutDate').value;
                        const roomSelect = document.getElementById('roomId');
                        const loading = document.getElementById('loadingRooms');

                        if (checkIn && checkOut) {
                            roomSelect.disabled = true;
                            loading.style.display = 'inline';

                            fetch('RoomController?action=available&checkIn=' + checkIn + '&checkOut=' + checkOut)
                                .then(response => response.json())
                                .then(data => {
                                    roomSelect.innerHTML = '<option value="">Select a Room</option>';
                                    data.forEach(room => {
                                        const option = document.createElement('option');
                                        option.value = room.roomId;
                                        option.text = `Room ${room.roomId} (${room.roomType}) - $${room.price}`;
                                        roomSelect.add(option);
                                    });
                                    roomSelect.disabled = false;
                                    loading.style.display = 'none';
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    loading.innerText = 'Error loading rooms';
                                });
                        }
                    }
                </script>
                </div>
                </div>
            </body>

            </html>