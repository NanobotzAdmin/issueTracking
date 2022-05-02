<%-- 
    Document   : myTicket_management
    Created on : Dec 17, 2021, 10:45:27 AM
    Author     : buddh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div class="row">
    <div class="col-sm-6">
        <div class="row">
            <div class="col-sm-4">
                <div class="widget widget-stats bg-black mb-7px">
                    <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
                    <div class="stats-content">
                        <div class="stats-title">Tasks In Queues</div>
                        <div class="stats-number text-center">19</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="widget widget-stats bg-black mb-7px">
                    <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
                    <div class="stats-content">
                        <div class="stats-title">Unassigned Tickets</div>
                        <div class="stats-number text-center">8</div>
                    </div>
                </div>
            </div>

            <div class="col-sm-4">
                <div class="widget widget-stats bg-black mb-7px">
                    <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
                    <div class="stats-content">
                        <div class="stats-title">Average Queue Time</div>
                        <div class="stats-number text-center">2<span style="font-size: 14px">Days</span></div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="col-sm-2">

    </div>

    <div class="col-sm-4">
        <div class="row">
            <div class="col-sm-6">
                <button type="button" class="btn btn-success">Create Ticket</button>
            </div>
            <div class="col-sm-6">
                <button type="button" class="btn btn-info">My Tickets</button>
            </div>
        </div>
    </div>
</div>

<br>

<h1 class="page-header"> My Tickets</h1>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Category</label>
                        <select class="default-select2 form-control">
                            <option>Select One</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Sub-Category</label>
                        <select class="default-select2 form-control">
                            <option>Select One</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Date Range</label>
                        <div class="input-group" id="default-daterange">
                            <input type="text" name="default-daterange" class="form-control" value="" placeholder="click to select the date range" />
                            <div class="input-group-text"><i class="fa fa-calendar"></i></div>
                        </div>
                    </div>
                </div>
            </div>
            <br>
            <div class="panel panel-inverse">
                <div class="panel-body">
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="data-table-default" class="table table-striped table-bordered align-middle">
                                    <thead>
                                        <tr>
                                            <th>Ticket</th>
                                            <th>Ticket Title</th>
                                            <th>Category</th>
                                            <th>Sub</th>
                                            <th>Status</th>
                                            <th>Assigned</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="odd gradeX">
                                            <td></td>
                                            <td> </td>
                                            <td></td>
                                            <td> </td>
                                            <td> </td>
                                            <td>
                                                <div class="avatars">
                                                    <span class="avatar">
                                                        <img src="assets/img/user/user-1.jpg" class=" rounded-pill" />
                                                    </span>
                                                    <span class="avatar">
                                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                                    </span>
                                                </div>
                                            </td>
                                            <td> <button type="button" class="btn btn-info btn-xs"><i class="far fa-eye"></i></button></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <label class="form-label col-form-label col-md-9"></label>
                <div class="col-md-3">
                    <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                </div>
            </div>


        </div>


        <!--start new ticket--> 
        <div class="row">
            <div class="col-sm-12">
                <h1 class="page-header"> New Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> #HW423 </small></h1>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-group mb-3">
                                    <label>Ticket Title</label>
                                    <input type="text" class="form-control">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Category</label>
                                    <select class="default-select2 form-control">
                                        <option>Select One</option>
                                    </select>
                                </div>
                                <div class="form-group mb-3">
                                    <label>Sub-Category</label>
                                    <select class="default-select2 form-control">
                                        <option>Select One</option>
                                    </select>
                                </div>

                                <div class="form-group mb-3">
                                    <div class="avatars">
                                        <span class="avatar">
                                            <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                        </span>
                                    </div> &nbsp;&nbsp;
                                    <label style="font-size: 14px">Ticket Details</label>
                                    <textarea class="summernote" name="content" style="color: #000"></textarea>
                                </div>


                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <input type="file" class="form-control">
                                    </div>
                                    <label class="form-label col-form-label col-md-5"></label>
                                    <div class="col-md-3">
                                        <button type="button" class="btn btn-green" style="width: 100%">Create Ticket</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--end new ticket-->

        <!--start confirm ticket-->
        <div class="row">
            <div class="col-sm-12">
                <div class="row">
                    <div class="col-sm-6">
                        <h1 class="page-header">  Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> #HW423 </small> &nbsp;&nbsp;
                            <div class="avatars">
                                <span class="avatar">
                                    <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                </span>
                            </div> 
                        </h1>
                    </div>
                    <div class="col-sm-1"></div>
                    <div class="col-sm-5">
                        <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash"></i></button>
                        <button type="button" class="btn btn-gray btn-sm"><i class="fa fa-arrow-right"></i></button>
                        <button type="button" class="btn btn-info btn-sm">Confirm Complete</button>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-2">
                        <label>Assigned to</label>
                    </div>
                    <div class="col-sm-6">
                        <div class="avatars">
                            <span class="avatar">
                                <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                            </span>
                            <span class="avatar">
                                <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                            </span>
                            <span class="avatar">
                                <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                            </span>
                            <span class="avatar">
                                <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                            </span>
                        </div> 
                    </div>
                    <div class="col-sm-4">
                        <label><b>Total Expenses</b> &nbsp;&nbsp;&nbsp; 325,000 Rs</label>
                    </div>
                </div>

                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <h4>New Branch Security</h4>
                        <label>
                            Jaffna new branch does not have a CCTV security at the movement,please take a necessary action to fix this.
                        </label>
                        <br> <br>
                        <input type="file" class="form-control">
                    </div>
                </div>


                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-sm-5">
                                        <div class="avatars">
                                            <span class="avatar">
                                                <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                            </span>
                                        </div> &nbsp;&nbsp;
                                        <label style="font-size: 14px">Bandara</label>
                                    </div>
                                    <div class="col-sm-4">
                                        <label>12.20AM &nbsp; 2021/12/19</label>
                                    </div>
                                    <div class="col-sm-3">
                                        <label>Cost 0.00 Rs</label>
                                    </div>
                                </div>
                                <br>
                                <label>We have now called in for quotation for CCTV service provider in the area this is the list</label>
                                <br>
                                <input type="file" class="form-control">
                                <br><br>
                                <div class="row mb-3">
                                    <div class="form-group col-md-6">
                                        <label>Add User to Ticket</label>
                                        <select class="default-select2 form-control" style="color: #000">
                                            <option>Select One</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label></label><br>
                                        <button type="button" class="btn btn-green">Add</button>
                                    </div>
                                </div>
                                <div class="form-group mb-3">
                                    <div class="avatars">
                                        <span class="avatar">
                                            <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                        </span>
                                    </div> &nbsp;&nbsp;
                                    <label style="font-size: 14px">Reply to Ticket</label>
                                    <textarea class="summernote" name="content" style="color: #000"></textarea>
                                </div>


                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <input type="file" class="form-control">
                                    </div>
                                    <label class="form-label col-form-label col-md-2"></label>
                                    <div class="col-md-3">
                                        <input type="text" class="form-control" placeholder="0.00">
                                    </div>
                                    <div class="col-md-3">
                                        <button type="button" class="btn btn-primary" style="width: 100%">Send Reply</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--end confirm ticket-->
    </div>
</div>



<script>

    $(".default-select2").select2();

    $('#data-table-default').DataTable({
        responsive: true
    });

    $("#default-daterange").daterangepicker({
        opens: "right",
        format: "MM/DD/YYYY",
        separator: " to ",
        startDate: moment().subtract("days", 29),
        endDate: moment(),
        minDate: "01/01/2021",
        maxDate: "12/31/2021",
    }, function (start, end) {
        $("#default-daterange input").val(start.format("MMMM D, YYYY") + " - " + end.format("MMMM D, YYYY"));
    });

    $(".summernote").summernote({
        placeholder: 'Hi, this is summernote. Please, write text here! Super simple WYSIWYG editor on Bootstrap',
        height: "150",
        color: "#000"
    });

</script>