
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <title>Predefined Services</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap-3.3.7/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.1.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>

    <style type="text/css">
        body{
            background:url(${pageContext.request.contextPath}/resources/images/93742-d09dd7090171c70be749072814043b26.jpg);
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function(){
           document.getElementById("add").disabled=true;
            var table =$("#detail");

            $("#serviceName").keyup(function(){
                if(this.value.length!=0 && $("#description").val().length!=0 && $("#duration").val().length!=0 && $("#cost").val().length!=0 && $("#type").val()!=="--Select Type--")
                    document.getElementById("add").disabled=false;
                else
                    document.getElementById("add").disabled=true;

            });

            $("#description").keyup(function(){
                if(this.value.length!=0 && $("#serviceName").val().length!=0 && $("#duration").val().length!=0 && $("#cost").val().length!=0 && $("#type").val()!=="--Select Type--")
                    document.getElementById("add").disabled=false;
                else
                    document.getElementById("add").disabled=true;
            });

            $("#type").change(function(){
                if(this.value!="--Select Type--" && $("#description").val().length!=0 && $("#duration").val().length!=0 && $("#cost").val().length!=0 && $("#serviceName").val().length!=0)
                    document.getElementById("add").disabled=false;
                else
                    document.getElementById("add").disabled=true;
            });

            $("#duration").keyup(function(){
                if(this.value.length!=0 && $("#description").val().length!=0 && $("#serviceName").val().length!=0 && $("#cost").val().length!=0 && $("#type").val()!=="--Select Type--")
                    document.getElementById("add").disabled=false;
                else
                    document.getElementById("add").disabled=true;
            });

            $("#cost").keyup(function(){
                if(this.value.length!=0 && $("#description").val().length!=0 && $("#duration").val().length!=0 && $("#serviceName").val().length!=0 && $("#type").val()!="--Select Type--")
                    document.getElementById("add").disabled = false;
                else
                    document.getElementById("add").disabled=true;
            });


            $("#add").click(function(){
                    var type= document.getElementById("type").value;
                    var duration= document.getElementById("duration").value;
                    var cost = document.getElementById("cost").value;
                    var markup = "<tr><tr><td><input type='checkbox' name='record'></td><td>"+type+"</td><td>" + duration + "</td><td>" + cost + "</td></tr>";
                    $("table tbody").append(markup);
                    document.getElementById("type").value = "--Select Type--";
                    document.getElementById("duration").value = "";
                    document.getElementById("cost").value = "";
                    document.getElementById("add").disabled=true;
            });

            $("#submit").click(function(){
                var data=[];
                data.push(document.getElementById("serviceName").value);
                data.push(document.getElementById("description").value);


               $("table").find("tr").each(function() {
                    $(this).find("td").each(function () {
                        if($(this).text()!=""){
                            data.push($(this).text());
                        }
                    });
                });
                var formAction = $('#service').attr('action');
                $('#service').attr('action', formAction + data);
            });

            $("#deleteSelected").click(function(){
                $("table tbody").find('input[name="record"]').each(function(){
                    if($(this).is(":checked")){
                        $(this).parents("tr").remove();
                    }
                });
            });

        });

    </script>
</head>

<div id="header">
    <%@ include file="fragments/header.jspf" %>
</div>

<body>
<div class="container">
    <div class="panel panel-primary">
        <div class="panel-heading"><h1>Add Predefined Service</h1></div>
        <div class="panel-body">
            <form id="service" class="form-horizontal" method="POST" action="addServicesData/">

                <div class="form-group">
                    <label class="control-label col-sm-2">Service Name:</label>
                    <div class="col-sm-6">
                        <input id="serviceName" type="text" class="form-control" name="serviceName" placeholder="Enter Service Name">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Description:</label>
                    <div class="col-sm-6">
                        <textarea id="description" rows="4" cols="50" class="form-control" name="description" placeholder="Enter Description"></textarea>
                    </div>
                </div>
                <hr>

                <div class="form-group">
                    <label class="control-label col-sm-2">Vehicle Type:</label>
                    <div class="col-sm-6">
                        <select id="type" class="form-control" name="vehicleType">
                            <option active>--Select Type--</option>
                            <option>Car</option>
                            <option>Bus</option>
                            <option>Van</option>
                            <option>3 Wheeler</option>
                        </select>
                        <a href="#">Add New Vehicle Type</a>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Duration:</label>
                    <div class="col-sm-6">
                        <input id="duration" type="text" class="form-control" name="duration" placeholder="Enter Duration(min)">
                    </div>
                </div>


                <div class="form-group">
                    <label class="control-label col-sm-2">Cost:</label>
                    <div class="col-sm-6">
                        <input id="cost" type="text" class="form-control" name="cost" placeholder="Enter Cost(Rs)">
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-8">
                            <button id="add" type="button" class="btn btn-success">Add Service</button>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-8">
                        <table id="detail" class="table table-bordered">
                            <thead>
                                <th>Select</th>
                                <th>Vehicle Type</th>
                                <th>Duration(mins)</th>
                                <th>Cost(Rs)</th>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button id="deleteSelected" type="button" class="btn btn-primary">Delete Selected Rows</button>
                        <button id="submit" class="btn btn-success">Submit</button>
                    </div>
                </div>

            </form>



        </div>
    </div>
</div>

</body>
</html>


