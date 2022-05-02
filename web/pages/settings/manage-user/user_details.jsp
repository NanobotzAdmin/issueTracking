<%-- 
    Document   : user_details
    Created on : Nov 27, 2021, 11:06:02 PM
    Author     : buddh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<h1 class="page-header">User Management</h1>

<div class="panel panel-inverse">
    <div class="panel-body">
        <div class="card">
            <div class="card-body">
                <table id="data-table-default" class="table table-striped table-bordered align-middle">
                    <thead>
                        <tr>
                            <th width="1%">EID</th>
                            <th>Name</th>
                            <th class="text-nowrap">Locations</th>
                            <th class="text-nowrap">Queues</th>
                            <th class="text-nowrap">Designation</th>
                            <th class="text-nowrap"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="odd gradeX">
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>
                                <button class="btn btn-outline-info btn-sm">View</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $('#data-table-default').DataTable({
        responsive: true
    });
</script>