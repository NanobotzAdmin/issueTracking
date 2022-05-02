<%-- 
    Document   : user_details_2
    Created on : Nov 27, 2021, 11:16:05 PM
    Author     : buddh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<h1 class="page-header">User Details</h1>

<div class="panel panel-inverse">
    <div class="panel-body">
        <div class="card">
            <div class="card-body">

                <div class="form-group mb-3">
                    <label>First Name</label>
                    <input type="text" class="form-control" id="fName" name="fName">
                </div>
                <div class="form-group mb-3">
                    <label>Last Name</label>
                    <input type="text" class="form-control" id="lName" name="lName">
                </div>
                <div class="row mb-3">
                    <div class="form-group col-md-6">
                        <label>NIC or Passport</label>
                        <input type="text" class="form-control" id="nic" name="nic">
                    </div>
                    <div class="form-group col-md-6">
                        <label>Date of Birth</label>
                        <input type="date" class="form-control"/>
                    </div>
                </div>
                <div class="form-group mb-3">
                    <label>Mobile</label>
                    <input type="text" class="form-control" id="mobile" name="mobile">
                </div>
                <div class="form-group mb-3">
                    <label>E-mail</label>
                    <input type="email" class="form-control" id="email" name="email">
                </div>
                <div class="row mb-3">
                    <div class="form-group col-md-6">
                        <label>Gender</label>
                        <select class="form-control" id="gender" name="gender">
                            <option></option>
                        </select>
                    </div>
                    <div class="form-group col-md-6">
                        <label>Marital Status</label>
                        <select class="form-control" id="maritalStatus" name="maritalStatus">
                            <option></option>
                        </select>
                    </div>
                </div>
                <div class="form-group mb-3">
                    <label>Designation</label>
                    <select class="form-control" id="designation" name="designation">
                        <option></option>
                    </select>
                </div>
                <div class="form-group mb-3">
                    <label>Locations</label>
                    <ul id="jquery-tagIt-default">
                        <li>Tag1</li>
                        <li>Tag2</li>
                    </ul>
                </div>
                <div class="form-group mb-3">
                    <label>Employee ID</label>
                    <input type="text" class="form-control" id="empId" name="empId">
                </div>
                <div class="row mb-5">
                    <div class="form-group col-md-6">
                        <label></label>
                        <input type="file" class="form-control-file btn btn-default" id="exampleFormControlFile1">
                    </div>
                    <div class="form-group col-md-6">
                        <label></label>
                        <button type="button" class="btn btn-success">Save Changes</button>
                    </div>
                </div>

              
            </div>
        </div>
    </div>
</div>

<script type="text/javascripts">
//     $("#datepicker-autoClose").datepicker({
//    todayHighlight: true,
//    autoclose: true
//  });
  
   $("#jquery-tagIt-default").tagit({
    availableTags: ["c++", "java", "php", "javascript", "ruby", "python", "c"]
  });
  
  
</script>
