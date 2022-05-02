<%-- 
    Document   : queue_technical
    Created on : Dec 1, 2021, 12:37:09 PM
    Author     : buddh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<h1 class="page-header">Queues</h1><br>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <div class="row mb-3">
                <div class="col-md-1">
                    <button type="button" class="btn btn-outline-white">Back</button>
                </div>
                <div class="col-md-3">
                    <h4>Technical Queue</h4>
                </div>
            </div>
            <div class="form-group row">
                <h4 class="col-sm-9">Assigned Category List</h4>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-outline-success" style="width: 100%">Create Category</button>
                </div>
            </div><br>
            <div class="panel panel-inverse">
                <div class="panel-body">
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="data-table-default" class="table table-striped table-bordered align-middle">
                                    <thead>
                                        <tr>
                                            <th>Category</th>
                                            <th>Sub Categories</th>
                                            <th>Members</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="odd gradeX">
                                            <td>Hardware</td>
                                            <td>
                                                <span class="badge bg-success">Hardware</span>
                                                <span class="badge bg-success">Software</span>
                                            </td>
                                            <td>45</td>
                                            <td>
                                                <button class="btn btn-outline-warning btn-sm">Manage</button>
                                            </td>
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


            <!--start queue details-->
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Queue Details</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Queue Name</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Short Description</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Status</label>
                                        <select class="form-control">
                                            <option></option>
                                        </select>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Assigned Users</label>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>EID</th>
                                                        <th>Name</th>
                                                        <th>Designation</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td><button type="button" class="btn btn-danger"><span class="fa fa-times"></span></button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Select User</label>
                                            <select class="form-control" style="color: #000">
                                                <option></option>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label></label><br>
                                            <button type="button" class="btn btn-green">Add</button>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-9"></label>
                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-green" style="width: 100%">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end queue details-->
            
            <!--start new queue-->
             <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header">New Queue</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Queue Name</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Short Description</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Status</label>
                                        <select class="form-control">
                                            <option></option>
                                        </select>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Assigned Users</label>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>EID</th>
                                                        <th>Name</th>
                                                        <th>Designation</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td><button type="button" class="btn btn-danger"><span class="fa fa-times"></span></button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Select User</label>
                                            <select class="form-control" style="color: #000">
                                                <option></option>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label></label><br>
                                            <button type="button" class="btn btn-green">Add</button>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-9"></label>
                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-green" style="width: 100%">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end new queue-->
            
            <!--start queue activity-->
            <div class="row">
                <div class="col-sm-12">
                     <h1 class="page-header"> Queue Activity</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Timestamp</th>
                                                    <th>Activity Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end queue activity-->

        </div>
    </div>
</div>



<script>

    $('#data-table-default').DataTable({
        responsive: true
    });

    
</script>