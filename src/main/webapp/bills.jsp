<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.oceanview.model.Bill" %>
            <%@ page import="com.oceanview.dao.BillDAO" %>
                <%@ page import="com.oceanview.dao.PaymentDAO" %>
                    <%@ page import="com.oceanview.model.Payment" %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Manage Bills - OceanView Resort</title>
                            <!-- Bootstrap 5 CSS -->
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <!-- Font Awesome -->
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                            <style>
                                :root {
                                    --main-bg-color: #009d63;
                                    --main-text-color: #009d63;
                                }

                                body {
                                    background-color: #f8f9fa;
                                }

                                .sidebar-heading {
                                    padding: 20px;
                                    font-size: 1.2rem;
                                    color: var(--main-text-color);
                                }

                                .list-group-item {
                                    border: none;
                                    padding: 15px 30px;
                                }

                                .list-group-item.active {
                                    background-color: #c1efde;
                                    color: var(--main-text-color);
                                    border: none;
                                    font-weight: bold;
                                }

                                .card {
                                    border: none;
                                    border-radius: 15px;
                                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                                }
                            </style>
                        </head>

                        <body>
                            <div class="d-flex" id="wrapper">
                                <!-- Sidebar -->
                                <div class="bg-white" id="sidebar-wrapper">
                                    <div
                                        class="sidebar-heading text-center py-4 primary-text fs-4 fw-bold text-uppercase border-bottom">
                                        <i class="fas fa-hotel me-2"></i>OceanView
                                    </div>
                                    <div class="list-group list-group-flush my-3">
                                        <a href="DashboardServlet"
                                            class="list-group-item list-group-item-action bg-transparent second-text fw-bold">
                                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                        </a>
                                        <a href="ReservationController?action=list"
                                            class="list-group-item list-group-item-action bg-transparent second-text fw-bold">
                                            <i class="fas fa-calendar-check me-2"></i>Reservations
                                        </a>
                                        <a href="billing?action=history"
                                            class="list-group-item list-group-item-action bg-transparent second-text active">
                                            <i class="fas fa-file-invoice-dollar me-2"></i>Bills & Payments
                                        </a>
                                        <a href="LogoutServlet"
                                            class="list-group-item list-group-item-action bg-transparent text-danger fw-bold">
                                            <i class="fas fa-power-off me-2"></i>Logout
                                        </a>
                                    </div>
                                </div>

                                <!-- Page Content -->
                                <div id="page-content-wrapper" class="w-100">
                                    <nav class="navbar navbar-expand-lg navbar-light bg-transparent py-4 px-4">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-align-left primary-text fs-4 me-3" id="menu-toggle"></i>
                                            <h2 class="fs-2 m-0">Bill Management</h2>
                                        </div>
                                    </nav>

                                    <div class="container-fluid px-4">
                                        <div class="row my-5">
                                            <div class="col">
                                                <div class="card p-4">
                                                    <h3 class="fs-4 mb-3">All Bills</h3>
                                                    <div class="table-responsive">
                                                        <table class="table bg-white rounded shadow-sm table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>Bill ID</th>
                                                                    <th>Reservation ID</th>
                                                                    <th>Date</th>
                                                                    <th>Room Charge</th>
                                                                    <th>Extra Charges</th>
                                                                    <th>Total</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% BillDAO billDAO=new BillDAO(); PaymentDAO
                                                                    paymentDAO=new PaymentDAO(); List<Bill> bills =
                                                                    billDAO.getAllBills();
                                                                    if (bills != null && !bills.isEmpty()) {
                                                                    for (Bill b : bills) {
                                                                    List<Payment> payments =
                                                                        paymentDAO.getPaymentsByBillId(b.getBillId());
                                                                        String status = payments.isEmpty() ? "Unpaid" :
                                                                        "Paid";
                                                                        String badgeClass = payments.isEmpty() ?
                                                                        "bg-warning" : "bg-success";
                                                                        %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= b.getBillId() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= b.getReservationId() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= b.getBillDate() %>
                                                                            </td>
                                                                            <td>$<%= b.getRoomCharge() %>
                                                                            </td>
                                                                            <td>$<%= b.getExtraChargesTotal() %>
                                                                            </td>
                                                                            <td class="fw-bold">$<%= b.getTotalAmount()
                                                                                    %>
                                                                            </td>
                                                                            <td><span
                                                                                    class="badge rounded-pill <%= badgeClass %>">
                                                                                    <%= status %>
                                                                                </span></td>
                                                                        </tr>
                                                                        <% } } else { %>
                                                                            <tr>
                                                                                <td colspan="7"
                                                                                    class="text-center text-muted">No
                                                                                    bills found.</td>
                                                                            </tr>
                                                                            <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Bootstrap JS Bundle -->
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                var el = document.getElementById("wrapper");
                                var toggleButton = document.getElementById("menu-toggle");
                                toggleButton.onclick = function () {
                                    el.classList.toggle("toggled");
                                };
                            </script>
                        </body>

                        </html>