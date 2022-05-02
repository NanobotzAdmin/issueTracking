<%-- 
    Document   : queue_category
    Created on : Dec 1, 2021, 1:19:23 PM
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
                    <h4>Hardware Category</h4>
                </div>
            </div>
            <div class="form-group row">
                <h4 class="col-sm-9">Assigned Sub Category List</h4>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-outline-success" style="width: 100%">Create Sub Category</button>
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
                                            <th>Sub Categories</th>
                                            <th>Members</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="odd gradeX">
                                            <td>CPU </td>
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




            <!--start category details-->
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Category Details</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Category Name</label>
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
            <!--end category details-->

            <!--start sub category details-->
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header">Sub Category Details</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Sub Category Name</label>
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
            <!--end sub category details-->

            <!--start sub category details 2-->
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header">Sub Category Details</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Sub Category Name</label>
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
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                   
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
                                    <br>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <button type="button" class="btn btn-danger" style="width: 100%">Delete</button>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <button type="button" class="btn btn-green" style="width: 100%">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end sub category details 2-->

        </div>
    </div>
</div>



<script>

    $('#data-table-default').DataTable({
        responsive: true
    });


</script>