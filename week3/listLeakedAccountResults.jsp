<%-- 
    Document   : listLeakedAccountResults
    Created on : 02.Tem.2018, 15:42:39
    Author     : ismail.okutucu
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="leakedAccounts.title"/></title>
    </head>
    <body>
   
        <biznet:mainPanel viewParams="title,search,body">
            <jsp:attribute name="title">
                <ul class="page-breadcrumb breadcrumb"> <li>
                        <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                        <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                    </li>
                    <li>
                        <span class="title2"><spring:message code="leakedAccounts.title"/></span>
                    </li>
                </ul>


            </jsp:attribute>
            <jsp:attribute name="search">
            <div class="row" style="height: 20px;">
                <label class="col-md-1 control-label" style="top: 8px;"><b><spring:message code="generic.account"/></b></label>
                <div class="col-lg-2">
                    <input class="form-control" id ="username" name="username">
                </div>
                <label class="col-md-1 control-label" style="top: 8px;"><b><spring:message code="listScans.source"/></b></label>
                <div class="col-md-2">
                    <input class="form-control" id ="source" name="source">
                </div>
                <div class="col-md-6 right" style="float:right">
                    <button type="button" onClick="refreshTable()" class="btn btn-primary right" id="search" style="float:right;margin-left:0.2em"><spring:message code="generic.search"/></button>
                    <button type="button" onClick="clearInDiv()" class="btn btn-info right" id="clear" style="float:right"><spring:message code="generic.clear"/></button>      
                </div>
            </div>
        </jsp:attribute>
            <jsp:attribute name="script">
            <style>      
                               
            #serverDatatables_processing
            {
                 margin-top: -3.5%;      
                 z-index: 1200;              
            }
           
            </style>     
            
                <script type="text/javascript">
                    document.title = "<spring:message code="leakedAccounts.title"/> - BIZZY";
                    var oTable;
                     $(document).ready(function () {
                    oTable = $('#serverDatatables').dataTable({
                        
                            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                            "processing": true,
                            "serverSide": true,
                            "searching": false,
                            "paging": true,
                            "scrollX": true,
                            "order": [],
                            "language": {
                                "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                                "processing": "<spring:message code="generic.tableLoading"/>",
                                "search": "<spring:message code="generic.search"/>  ",
                                "paginate": {
                                    "next": "<spring:message code="generic.next"/>",
                                    "previous": "<spring:message code="generic.back"/>"
                                },
                                "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                                "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                                "infoEmpty":  "<spring:message code="generic.tableInfo" arguments="${'0'},${'0'},${'0'}"/>" 
                            },
                            "destroy": true,
                            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                            "columnDefs": [ {
                                "targets": 6,
                                "data": null,
                                "defaultContent": '<button type="button" class="btn btn-danger btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="listPhishingResults.createTicket"/>"><i class="far fa-calendar"></i></button>'
                            } ],
                            "columns": [
                                {
                                    "data": "leakedAccountAlertResultDataId",
                                    render: function (data, type, row) {
                                        return '<input type="checkbox" class="editor-active" id="checkLeakedAccountAlerts" value="' + data + '" >';
                                    },
                                    className: "dt-body-center",
                                    "searchable": false,
                                    "orderable": false
                                },
                                {
                                    "data": 'username',
                                    "orderable": false,
                                    "render": function (data) {
                                        if (data !== null)
                                            return data;
                                        else
                                            return '<div><i class="fas fa-minus"></i></div>';
                                    }
                                },
                                {
                                    "data": 'password',
                                    "orderable": false,
                                    "render": function (data) {
                                        if (data !== null)
                                            return data;
                                        else
                                            return '<div><i class="fas fa-minus"></i></div>';
                                    }
                                },
                                {
                                    "data": 'source',
                                    "render": function (data) {
                                        if (data !== null)
                                            return '<div>'+data+'</div>';
                                        else
                                            return '<div><i class="fas fa-minus"></i></div>';
                                    }
                                },
                                {
                                    "data": 'leakedAccountAlertResult.alertName'
                                },
                                {
                                    "data": 'leakedAccountAlertResult.createDate'
                                },
                                {"data": function (data, type, dataToSet) {
                                    },
                                    "searchable": false,
                                    "orderable": false
                                }
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadLeakedAccount.json",
                                "data": function (d) {
                                            d.username = $('#username').val(),
                                            d.source =   $('#source').val(),   
                                            d.${_csrf.parameterName} = "${_csrf.token}";
                                },
                                "error": function (jqXHR, textStatus, errorThrown) {
                                    console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="listCategories.tableError"/>");
                                    $("#alertModal").modal("show");
                                }
                            },
                            
                            "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                        });
                        $('#serverDatatables tbody').on( 'click', 'button', function () {
                            var row = $(this).closest("tr");
                            var table = row.closest('table').dataTable();
                            var rowData = table.api().row( row ).data();
                            var alertName = <c:out value = "rowData.leakedAccountAlertResult.alertName"/>;
                            var createDate = <c:out value = "rowData.leakedAccountAlertResult.createDate"/>;
                            var username = <c:out value = "rowData.username"/>;
                            var password = <c:out value = "rowData.password"/>;
                            var source = <c:out value = "rowData.source"/>;
                            var descStr = "";
                            descStr += "<spring:message code="generic.account"/>: "+username+"\n";
                            descStr += "<spring:message code="editSettings.password"/>: "+password+"\n";
                            descStr += "<spring:message code="listScans.source"/>: "+source+"\n";
                            descStr += "<spring:message code="ti.alertName"/>: "+alertName+"\n";
                            descStr += "<spring:message code="listVulnerabilities.creationDate"/>: "+createDate+"\n";                    
                            $("#ticketName").val('<spring:message code="listLeakedAccountResults.single"/>: ' + decodeHtml(username));
                            $("#ticketDescription").val(descStr);
                            $("#createTicketModal").modal();
                        } );
                    });
                    
                    function refreshTable() {
                       $("#serverDatatables").dataTable().api().draw();
                    }
                    function clearInDiv() {
                        $("#source").val("");
                        $("#username").val("");
                    }
                    $('#scanModal').on("hidden.bs.modal", function () {
                        $('#usernameMore').empty();
                        $('#passwordMore').empty();
                        $('#sourceMore').empty();
                    });

                    function deleteAlert() {
                        var alertIds = [];
                        $('input[id=checkLeakedAccountAlerts]:checked').each(function () {
                            alertIds.push($(this).val());
                        });
                        $.post("deleteTiData.json", {
                            'type': 'leakedAccount',
                            'alertIds[]': alertIds,
                    ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function () {
                            oTable.api().ajax.reload();
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                            $("#alertModal").modal("show");
                        }).always(function () {
                        });
                    }
                </script>
                <style>
                    p{
                        display:none;
                     }
                </style>
                <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
                <jsp:include page="/WEB-INF/jsp/ti/include/ticketModal.jsp" />
            </jsp:attribute>
            <jsp:body>
                
                <div><a class="btn btn-primary btn-info btn-sm" onclick="deleteAlert()" ><spring:message code="generic.delete"/></a> </div>
                <table style="width:100%;" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                    <thead class="datatablesThead">
                        <tr>
                            <th width="10px"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('checkLeakedAccountAlerts');"></th>
                            <th style="vertical-align: middle;width: 25%;"><spring:message code="generic.account"/></th>
                            <th style="vertical-align: middle;width: 10%;"><spring:message code="editSettings.password"/></th>
                            <th style="vertical-align: middle;width: 45%;"><spring:message code="listScans.source"/></th>
                            <th style="vertical-align: middle;width: 10%;"><spring:message code="ti.alertName"/></th>
                            <th style="vertical-align: middle;width: 10%;"><spring:message code="listVulnerabilities.creationDate"/></th>
                            <th style="min-width: 100px; width: 100px;" width="100px" class="sorting_disabled" rowspan="1" colspan="1" aria-label=" "> </th>
                        </tr>
                    </thead>                                
                </table>
                <div class="modal fade" id="scanModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog" >
                        <div class="modal-content" style="width:1000px;margin-left: -200px">
                            <div class="modal-header">
                                <h4 class="modal-title"><spring:message code="generic.details"/></h4>
                            </div>
                            <div class="modal-body" style="height: 500px;overflow-y: scroll;">
                                <div class="col-md-5">
                                    <div id="usernameMore" >
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div id="passwordMore" >
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div id="sourceMore" >
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <style>
                    .dataTables_length {
                        margin-top: 0px !important;
                        display: inline;
                        position: relative;
                        float: right;
                        z-index: 2;
                    }
                    .dataTables_wrapper{
                        margin-top: -30px;
                    }
                </style>
            </jsp:body>
        </biznet:mainPanel>
    </body>
</html>
