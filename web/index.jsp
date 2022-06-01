<%-- 
    Document   : index
    Created on : Nov 23, 2021, 1:09:09 PM
    Author     : dinuka
--%>

<%@page import="org.apache.log4j.Logger"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") == null) {
        Logger logger = Logger.getLogger(this.getClass().getName());
        try {
%>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Nanobotz: Issues Tracking Login</title>
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />
        
        <!--favicon start-->
        <link rel="apple-touch-icon" sizes="57x57" href="assets/img/favicon/apple-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="60x60" href="assets/img/favicon/apple-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="72x72" href="assets/img/favicon/apple-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/favicon/apple-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="114x114" href="assets/img/favicon/apple-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="120x120" href="assets/img/favicon/apple-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="144x144" href="assets/img/favicon/apple-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="152x152" href="assets/img/favicon/apple-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="assets/img/favicon/apple-icon-180x180.png">
        <link rel="icon" type="image/png" sizes="192x192"  href="assets/img/favicon/android-icon-192x192.png">
        <link rel="icon" type="image/png" sizes="32x32" href="assets/img/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="96x96" href="assets/img/favicon/favicon-96x96.png">
        <link rel="icon" type="image/png" sizes="16x16" href="assets/img/favicon/favicon-16x16.png">
        <link rel="manifest" href="assets/img/favicon/manifest.json">
        <meta name="msapplication-TileColor" content="#ffffff">
        <meta name="msapplication-TileImage" content="assets/img/favicon/ms-icon-144x144.png">
        <meta name="theme-color" content="#ffffff">
        <!--favicon end-->

        <!-- ================== BEGIN core-css ================== -->
        <link href="assets/css/vendor.min.css" rel="stylesheet" />
        <link href="assets/css/transparent/app.min.css" rel="stylesheet" />
        <!-- ================== END core-css ================== -->
        <!--sweet alert-->
        <link href="assets/css/sweetalert/sweetalert.css" rel="stylesheet" />

    </head>
    <body class='pace-top'>
        <!-- BEGIN page-cover -->
        <!--<div class="app-cover"></div>-->
        <!-- END page-cover -->

        <!-- BEGIN #loader -->
        <div id="loader" class="app-loader">
            <span class="spinner"></span>
        </div>
        <!-- END #loader -->


        <!-- BEGIN #app -->
        <div id="app" class="app">
            <!-- BEGIN login -->
            <div class="login login-v2 fw-bold">
                <!-- BEGIN login-cover -->
<!--                <div class="login-cover">
                    <div class="login-cover-img" style="background-image: url(assets/img/login-bg/login-bg-19.jpg)" data-id="login-cover-image"></div>
                    <div class="login-cover-bg"></div>
                </div>-->
                <!-- END login-cover -->

                <!-- BEGIN login-container -->
                <div class="login-container">
                    <!-- BEGIN login-header -->
                    <div class="login-header">
                        <div class="brand">
                            <div class="d-flex align-items-center">
                                <img src="assets/img/logo/white-logo.png" class="img-fluid" style="width:60px;"> <span style="font-size: large">&nbsp;Issues Tracking</span>
                            </div>
                            <small>Next Generation of Customer Service </small>
                        </div>
                        <div class="icon">
                            <i class="fa fa-lock"></i>
                        </div>
                    </div>
                    <!-- END login-header -->

                    <!-- BEGIN login-content -->
                    <div class="login-content">
                        <form action="index.html" method="GET">
                            <div class="form-floating mb-20px">
                                <input type="text" class="form-control fs-13px h-45px border-0" placeholder="Email Address" id="emailAddress" />
                                <label for="emailAddress" class="d-flex align-items-center text-dark fs-13px">Username</label>
                            </div>
                            <div class="form-floating mb-20px">
                                <input type="password" class="form-control fs-13px h-45px border-0" placeholder="Password" id="password" />
                                <label for="password" class="d-flex align-items-center text-dark fs-13px">Password</label>
                            </div>
                            <!--                            <div class="form-check mb-20px">
                                                            <input class="form-check-input border-0" type="checkbox" value="1" id="rememberMe" />
                                                            <label class="form-check-label fs-13px text-gray-500" for="rememberMe">
                                                                Remember Me
                                                            </label>
                                                        </div>-->
                            <div class="mb-20px" id="lOGINDIV">
                                <input type="button" class="btn btn-warning d-block w-100 h-45px btn-lg" onclick="userLogin()" value="Sign me in">
                            </div>
<!--                            <div class="text-gray-500">
                                Not a member yet? Click <a href="javascript:;" class="text-white">here</a> to register.
                            </div>-->
                        </form>
                    </div>
                    <!-- END login-content -->
                </div>
                <!-- END login-container -->
            </div>
            <!-- END login -->

            <!-- BEGIN login-bg -->
<!--            <div class="login-bg-list clearfix">
                <div class="login-bg-list-item active"><a href="javascript:;" class="login-bg-list-link" data-toggle="login-change-bg" data-img="assets/img/login-bg/login-bg-19.jpg" style="background-image: url(assets/img/login-bg/login-bg-19.jpg)"></a></div>
                <div class="login-bg-list-item"><a href="javascript:;" class="login-bg-list-link" data-toggle="login-change-bg" data-img="assets/img/login-bg/login-bg-16.jpg" style="background-image: url(assets/img/login-bg/login-bg-16.jpg)"></a></div>
                <div class="login-bg-list-item"><a href="javascript:;" class="login-bg-list-link" data-toggle="login-change-bg" data-img="assets/img/login-bg/login-bg-15.jpg" style="background-image: url(assets/img/login-bg/login-bg-15.jpg)"></a></div>
                <div class="login-bg-list-item"><a href="javascript:;" class="login-bg-list-link" data-toggle="login-change-bg" data-img="assets/img/login-bg/login-bg-14.jpg" style="background-image: url(assets/img/login-bg/login-bg-14.jpg)"></a></div>
                <div class="login-bg-list-item"><a href="javascript:;" class="login-bg-list-link" data-toggle="login-change-bg" data-img="assets/img/login-bg/login-bg-13.jpg" style="background-image: url(assets/img/login-bg/login-bg-13.jpg)"></a></div>
                <div class="login-bg-list-item"><a href="javascript:;" class="login-bg-list-link" data-toggle="login-change-bg" data-img="assets/img/login-bg/login-bg-12.jpg" style="background-image: url(assets/img/login-bg/login-bg-12.jpg)"></a></div>
            </div>-->
            <!-- END login-bg -->


            <!-- BEGIN scroll-top-btn -->
            <a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top" data-toggle="scroll-to-top"><i class="fa fa-angle-up"></i></a>
            <!-- END scroll-top-btn -->
        </div>
        <!-- END #app -->

        <!-- ================== BEGIN core-js ================== -->
        <script src="assets/js/vendor.min.js"></script>
        <script src="assets/js/app.min.js"></script>
        <script src="assets/js/theme/transparent.min.js"></script>
        <!-- ================== END core-js ================== -->

        <!-- ================== BEGIN page-js ================== -->
        <script src="assets/js/demo/login-v2.demo.js"></script>
        <!-- ================== END page-js ================== -->
        <!--sweet alert-->
        <script src="assets/js/sweetalert/sweetalert.min.js"></script>
        <script type="text/javascript">
//    function for login                   
                                    function userLogin() {
                                        var emailAddress = $('#emailAddress').val();
                                        var password = $('#password').val();
                                        jQuery.ajax({
                                            url: "userManagement_userLogin",
                                            type: "POST",
                                            data: "emailAddress=" + emailAddress + "&password=" + password,
                                            beforeSend: function () {
                                                $('#lOGINDIV').empty();
                                                $('#lOGINDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
                                            },
                                            complete: function () {},
                                            success: function (data) {
                                                var resultValue = JSON.parse(data);
                                                if (resultValue.result === "0") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "warning");
                                                    $('#lOGINDIV').empty();
                                                    $('#lOGINDIV').html("<input type='button' class='btn btn-success d-block w-100 h-45px btn-lg' onclick='userLogin()' value='Sign me in'>");
                                                } else if (resultValue.result === "4") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "warning");
                                                    $('#lOGINDIV').empty();
                                                    $('#lOGINDIV').html("<input type='button' class='btn btn-success d-block w-100 h-45px btn-lg' onclick='userLogin()' value='Sign me in'>");
                                                } else if (resultValue.result === "3") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "warning");
                                                    $('#lOGINDIV').empty();
                                                    $('#lOGINDIV').html("<input type='button' class='btn btn-success d-block w-100 h-45px btn-lg' onclick='userLogin()' value='Sign me in'>");
                                                } else if (resultValue.result === "1") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "warning");
                                                    $('#lOGINDIV').empty();
                                                    $('#lOGINDIV').html("<input type='button' class='btn btn-success d-block w-100 h-45px btn-lg' onclick='userLogin()' value='Sign me in'>");
                                                } else if (resultValue.result === "2") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "success");
                                                    window.location.href = "home.jsp";
                                                } else if (resultValue.result === "6") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "warning");
                                                    $('#lOGINDIV').empty();
                                                    $('#lOGINDIV').html("<input type='button' class='btn btn-success d-block w-100 h-45px btn-lg' onclick='userLogin()' value='Sign me in'>");
                                                } else if (resultValue.result === "5") {
//                                                    alert(resultValue.displayMessage);
                                                    swal("", resultValue.displayMessage, "warning");
                                                    $('#lOGINDIV').empty();
                                                    $('#lOGINDIV').html("<input type='button' class='btn btn-success d-block w-100 h-45px btn-lg' onclick='userLogin()' value='Sign me in'>");
                                                }

                                            }
                                        });
                                    }
//function for enter key login function
                                    $(document).keypress(function (e) {
                                        if (e.which == 13) {
                                            userLogin();
                                        }
                                    });
        </script>
        <script type="text/javascript">
            function showLoaderIndex() {
                document.getElementById("loaderDivIndex").innerHTML = '<center><div style="display : block;position : fixed;z-index: 10000;background-color:#ffffff;opacity : 1.0;left : 0;bottom : 0;right : 0;top : 0;"><img style="z-index: 1000;position : center; margin-top:10%;max-width:100%;max-height:100%" src="img/loader2.gif"></div></center>';
            }

            function hideLoaderIndex() {
                document.getElementById("loaderDivIndex").innerHTML = '';
            }
        </script>


    </body>
</html>
<%
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
        }
    } else {
        response.sendRedirect("home.jsp");
    }


%>
