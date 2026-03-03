<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null) { response.sendRedirect("login.jsp"); return;
            } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>New Reservation - Ocean View Resort</title>
                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- FontAwesome 6 -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <!-- Custom CSS -->
                <link rel="stylesheet" href="css/style.css">
            </head>

            <body class="bg-light">
                <div class="container py-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-primary"><i class="fa-solid fa-plus-circle me-2"></i>Create Reservation
                        </h2>
                        <a href="dashboard.jsp" class="btn btn-outline-secondary"><i
                                class="fa-solid fa-arrow-left me-2"></i>Back to Dashboard</a>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <!-- Error Message -->
                            <% String error=(String) request.getAttribute("errorMessage"); if (error !=null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fa-solid fa-circle-exclamation me-2"></i>
                                    <%= error %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                </div>
                                <% } %>

                                    <div class="card shadow border-0">
                                        <div class="card-header bg-primary text-white py-3">
                                            <h5 class="mb-0 text-center"><i
                                                    class="fa-solid fa-user-pen me-2"></i>Reservation Details</h5>
                                        </div>
                                        <div class="card-body p-4">
                                            <form action="reservation" method="post" id="reservationForm">

                                                <!-- Guest Section -->
                                                <h5 class="text-muted border-bottom pb-2 mb-3">Guest Information</h5>

                                                <!-- Hidden Guest ID -->
                                                <input type="hidden" id="selectedGuestId" name="guestId" required>

                                                <!-- Selection Tabs -->
                                                <div class="d-flex gap-2 mb-3">
                                                    <button type="button" class="btn btn-primary flex-grow-1"
                                                        onclick="showTab('search')" id="btnSearch">
                                                        <i class="fa-solid fa-magnifying-glass me-2"></i>Search Guest
                                                    </button>
                                                    <button type="button" class="btn btn-outline-secondary flex-grow-1"
                                                        onclick="showTab('new')" id="btnNew">
                                                        <i class="fa-solid fa-user-plus me-2"></i>New Guest
                                                    </button>
                                                </div>

                                                <!-- Search Section -->
                                                <div id="searchGuestSection">
                                                    <div class="input-group mb-3">
                                                        <div class="form-floating flex-grow-1">
                                                            <input type="text" class="form-control" id="searchQuery"
                                                                placeholder="Email or Phone">
                                                            <label for="searchQuery">Search by Email or Contact
                                                                Number</label>
                                                        </div>
                                                        <button class="btn btn-primary px-4" type="button"
                                                            onclick="searchGuest()">Search</button>
                                                    </div>
                                                    <div id="searchResult" class="mb-3"></div>
                                                </div>

                                                <!-- New Guest Section -->
                                                <div id="newGuestSection" style="display: none;">
                                                    <div class="row g-2">
                                                        <div class="col-md-6">
                                                            <div class="form-floating mb-3">
                                                                <input type="text" class="form-control"
                                                                    id="newGuestName" placeholder="Full Name">
                                                                <label for="newGuestName">Full Name</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-floating mb-3">
                                                                <input type="email" class="form-control"
                                                                    id="newGuestEmail" placeholder="Email">
                                                                <label for="newGuestEmail">Email</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-floating mb-3">
                                                                <input type="tel" class="form-control"
                                                                    id="newGuestContact" placeholder="Phone">
                                                                <label for="newGuestContact">Contact Number</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-floating mb-3">
                                                                <input type="text" class="form-control"
                                                                    id="newGuestAddress" placeholder="Address">
                                                                <label for="newGuestAddress">Address</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <button type="button" class="btn btn-success w-100 mb-3"
                                                        onclick="createNewGuest()">
                                                        <i class="fa-solid fa-check me-2"></i>Create & Select Guest
                                                    </button>
                                                    <div id="createResult" class="mb-3"></div>
                                                </div>

                                                <!-- Selected Guest Display -->
                                                <div id="selectedGuestDisplay"
                                                    class="alert alert-success d-none align-items-center justify-content-between shadow-sm">
                                                    <div>
                                                        <i class="fa-solid fa-user-check me-2"></i>
                                                        <strong>Selected Guest:</strong> <span id="displayGuestName"
                                                            class="ms-1"></span>
                                                        <span
                                                            class="ms-2 badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">ID:
                                                            <span id="displayGuestId"></span></span>
                                                    </div>
                                                    <button type="button" class="btn btn-sm btn-success"
                                                        onclick="clearSelection()"><i
                                                            class="fa-solid fa-rotate me-1"></i> Change</button>
                                                </div>

                                                <!-- Stay Details -->
                                                <h5 class="text-muted border-bottom pb-2 mb-3 mt-4">Stay Details</h5>

                                                <div class="row g-2">
                                                    <div class="col-md-6">
                                                        <div class="form-floating mb-3">
                                                            <input type="date" class="form-control" id="checkInDate"
                                                                name="checkInDate" value="${checkInDate}" required>
                                                            <label for="checkInDate">Check-In Date</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-floating mb-3">
                                                            <input type="date" class="form-control" id="checkOutDate"
                                                                name="checkOutDate" value="${checkOutDate}" required>
                                                            <label for="checkOutDate">Check-Out Date</label>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-floating mb-4">
                                                    <select class="form-select" id="roomType" name="roomType" required>
                                                        <option value="Single" ${roomType=='Single' ? 'selected' : '' }>
                                                            Single</option>
                                                        <option value="Double" ${roomType=='Double' ? 'selected' : '' }>
                                                            Double</option>
                                                        <option value="Suite" ${roomType=='Suite' ? 'selected' : '' }>
                                                            Suite</option>
                                                    </select>
                                                    <label for="roomType">Room Type Preference</label>
                                                </div>
                                        </div>

                                        <div class="d-grid mt-4">
                                            <button type="submit" class="btn btn-primary btn-lg shadow-sm">
                                                <i class="fa-solid fa-paper-plane me-2"></i>Create Reservation
                                            </button>
                                        </div>

                                        </form>
                                    </div>
                        </div>
                    </div>
                </div>
                </div>

                <!-- Bootstrap JS Bundle -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    let currentSearchResults = {};

                    // Recovery Logic: If guestId is passed from servlet, try to fetch its full details
                    window.onload = function () {
                        const recoveredId = '${guestId}';
                        if (recoveredId && recoveredId !== '') {
                            console.log('--- Recovering Guest Selection ---');
                            console.log('Recovering ID:', recoveredId);

                            // Fetch full details from search to populate the UI correctly
                            fetch('GuestController?action=search&query=' + encodeURIComponent(recoveredId))
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        currentSearchResults[data.guestId] = data;
                                        selectGuest(data.guestId, data.name, data.email, data.contact, data.address);
                                    }
                                });
                        }
                    };

                    // Form Validation
                    document.getElementById('reservationForm').addEventListener('submit', function (event) {
                        const guestId = document.getElementById('selectedGuestId').value;
                        console.log('Form submission check. Selected Guest ID:', guestId);
                        if (!guestId) {
                            event.preventDefault(); // Stop submission
                            alert('Please select a guest before creating a reservation.');
                            document.getElementById('searchGuestSection').scrollIntoView({ behavior: 'smooth' });
                        }
                    });

                    function showTab(tab) {
                        document.getElementById('searchGuestSection').style.display = tab === 'search' ? 'block' : 'none';
                        document.getElementById('newGuestSection').style.display = tab === 'new' ? 'block' : 'none';

                        const btnSearch = document.getElementById('btnSearch');
                        const btnNew = document.getElementById('btnNew');

                        if (tab === 'search') {
                            btnSearch.classList.remove('btn-outline-secondary');
                            btnSearch.classList.add('btn-primary');
                            btnNew.classList.remove('btn-primary');
                            btnNew.classList.add('btn-outline-secondary');
                        } else {
                            btnNew.classList.remove('btn-outline-secondary');
                            btnNew.classList.add('btn-primary');
                            btnSearch.classList.remove('btn-primary');
                            btnSearch.classList.add('btn-outline-secondary');
                        }
                    }

                    function searchGuest() {
                        const query = document.getElementById('searchQuery').value;
                        if (!query) return;

                        console.log('--- Guest Search Started ---');
                        console.log('Query:', query);

                        fetch('GuestController?action=search&query=' + encodeURIComponent(query))
                            .then(response => {
                                console.log('HTTP Status:', response.status);
                                if (!response.ok) throw new Error('Network response was not ok');
                                return response.json();
                            })
                            .then(data => {
                                console.log('Parsed Search Data:', data);
                                const resultDisplay = document.getElementById('searchResult');
                                if (data.success) {
                                    console.log('Guest found. Populating results...');
                                    // Store data globally to avoid quoting issues in HTML attributes
                                    currentSearchResults[data.guestId] = data;

                                    resultDisplay.innerHTML = `
                            <div class="card border-success border-2 shadow-sm mb-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h5 class="card-title text-success mb-0">
                                            <i class="fa-solid fa-user-check me-2"></i>Guest Found
                                        </h5>
                                        <span class="badge bg-success">ID: \${data.guestId}</span>
                                    </div>
                                    <div class="row g-2 mb-3">
                                        <div class="col-12">
                                            <strong><i class="fa-solid fa-user me-2"></i>Name:</strong> \${data.name || 'N/A'}
                                        </div>
                                        <div class="col-md-6">
                                            <strong><i class="fa-solid fa-envelope me-2"></i>Email:</strong> \${data.email || 'N/A'}
                                        </div>
                                        <div class="col-md-6">
                                            <strong><i class="fa-solid fa-phone me-2"></i>Contact:</strong> \${data.contact || 'N/A'}
                                        </div>
                                        <div class="col-12">
                                            <strong><i class="fa-solid fa-location-dot me-2"></i>Address:</strong> \${data.address || 'N/A'}
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-success w-100 py-2 fw-bold" 
                                        onclick="selectGuestFromSearch('\${data.guestId}')">
                                        <i class="fa-solid fa-check-circle me-2"></i>Confirm and Select
                                    </button>
                                    <div class="mt-3 pt-2 border-top">
                                        <details>
                                            <summary class="small text-muted cursor-pointer" style="cursor:pointer">Technical Details (Debug)</summary>
                                            <pre class="small bg-light p-2 mt-1 rounded" style="font-size: 0.75rem;">\${JSON.stringify(data, null, 2)}</pre>
                                        </details>
                                    </div>
                                </div>
                            </div>`;
                                } else {
                                    console.log('No guest found for:', query);
                                    resultDisplay.innerHTML = `
                            <div class="alert alert-warning d-flex justify-content-between align-items-center shadow-sm">
                                <span><i class="fa-solid fa-circle-exclamation me-2"></i>Guest not found.</span>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="showTab('new')">Add New Guest</button>
                            </div>`;
                                }
                            })
                            .catch(error => {
                                console.error('--- Guest Search FAILED ---');
                                console.error(error);
                                document.getElementById('searchResult').innerHTML =
                                    '<div class="alert alert-danger">An error occurred while searching. Check console for details.</div>';
                            });
                    }

                    function createNewGuest() {
                        const formData = new URLSearchParams();
                        formData.append('action', 'add');
                        formData.append('guestName', document.getElementById('newGuestName').value);
                        formData.append('address', document.getElementById('newGuestAddress').value);
                        formData.append('contactNumber', document.getElementById('newGuestContact').value);
                        formData.append('email', document.getElementById('newGuestEmail').value);

                        console.log('--- Creating New Guest ---');
                        fetch('GuestController', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => {
                                if (!response.ok) throw new Error('Network response was not ok');
                                return response.json();
                            })
                            .then(data => {
                                console.log('Create result:', data);
                                const resultDisplay = document.getElementById('createResult');
                                if (data.success) {
                                    resultDisplay.innerHTML = '<div class="alert alert-success">Guest created successfully!</div>';

                                    // Store full data in global results to prevent "Session error"
                                    currentSearchResults[data.guestId] = data;

                                    console.log('Finalizing selection for new guest:', data.guestId);
                                    selectGuest(data.guestId, data.name, data.email, data.contact, data.address);
                                } else {
                                    resultDisplay.innerHTML = `<div class="alert alert-danger">Error: ${data.message}</div>`;
                                }
                            })
                            .catch(error => {
                                console.error('Create Request Failed:', error);
                            });
                    }

                    function selectGuestFromSearch(id) {
                        console.log('--- Selection Logic Started ---');
                        console.log('ID received:', id, 'Type:', typeof id);

                        // Try string lookup first, then number
                        let data = currentSearchResults[id];
                        if (!data) data = currentSearchResults[String(id)];
                        if (!data) data = currentSearchResults[parseInt(id)];

                        if (data) {
                            console.log('Found guest data:', data);
                            selectGuest(data.guestId, data.name, data.email, data.contact, data.address);
                        } else {
                            console.error('CRITICAL: Guest data not found in lookup for ID:', id);
                            console.log('Current Result Keys:', Object.keys(currentSearchResults));
                            alert('Selection Error: Guest data missing from session. ID: ' + id);
                        }
                    }

                    function selectGuest(id, name, email, contact, address) {
                        console.log('--- Final Selection Logic Started ---');
                        console.log('Arguments:', { id, name, email, contact, address });

                        const idField = document.getElementById('selectedGuestId');
                        if (!idField) {
                            console.error('ERROR: hidden field "selectedGuestId" not found');
                            return;
                        }
                        idField.value = id;

                        // Update display text
                        let displayText = `<strong>\${name}</strong>`;
                        if (email && email !== 'N/A') displayText += ` <span class="text-muted border-start ps-2 ms-2">\${email}</span>`;
                        if (contact && contact !== 'N/A') displayText += ` <span class="text-muted border-start ps-2 ms-2">\${contact}</span>`;

                        const nameDisplay = document.getElementById('displayGuestName');
                        const idDisplay = document.getElementById('displayGuestId');

                        if (nameDisplay) nameDisplay.innerHTML = displayText;
                        if (idDisplay) idDisplay.innerText = id;

                        // Check for the "false" issue
                        if (id === false || id === 'false' || name === 'false' || name === false) {
                            console.warn('WARNING: Received "false" as guest detail. Data corruption suspected.');
                        }

                        // Toggle visibility
                        const display = document.getElementById('selectedGuestDisplay');
                        if (display) {
                            console.log('Showing selectedGuestDisplay element...');
                            display.classList.remove('d-none');
                            display.classList.add('d-flex');
                            display.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        } else {
                            console.error('ERROR: element "selectedGuestDisplay" not found');
                        }

                        // Hide results and clear search query for a clean UI
                        const searchResult = document.getElementById('searchResult');
                        if (searchResult) searchResult.innerHTML = '';
                        const createResult = document.getElementById('createResult');
                        if (createResult) createResult.innerHTML = '';

                        // Collapse the search/new sections
                        document.getElementById('searchGuestSection').style.display = 'none';
                        document.getElementById('newGuestSection').style.display = 'none';

                        console.log('--- Selection Finalized ---');
                    }

                    function clearSelection() {
                        console.log('Clearing selection...');
                        document.getElementById('selectedGuestId').value = '';
                        const display = document.getElementById('selectedGuestDisplay');
                        if (display) {
                            display.classList.add('d-none');
                            display.classList.remove('d-flex');
                        }
                        // Re-show search section
                        showTab('search');
                    }

                    function checkAvailability() {
                        const checkIn = document.getElementById('checkInDate').value;
                        const checkOut = document.getElementById('checkOutDate').value;
                        const roomSelect = document.getElementById('roomId');
                        const loading = document.getElementById('loadingRooms');

                        if (checkIn && checkOut) {
                            roomSelect.disabled = true;
                            loading.style.display = 'block';

                            fetch('RoomController?action=available&checkIn=' + checkIn + '&checkOut=' + checkOut)
                                .then(response => response.json())
                                .then(data => {
                                    roomSelect.innerHTML = '<option value="">Select a Room</option>';
                                    data.forEach(room => {
                                        const option = document.createElement('option');
                                        option.value = room.roomId;
                                        option.text = `Room \${room.roomNumber || room.roomId} (\${room.roomType}) - $\${room.price}`;
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
            </body>

            </html>