<%-- 
    Document   : riskReport
    Created on : 19.Mar.2018, 11:26:51
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
        <title>Port Alarmı</title>
    </head>
    <biznet:mainPanel viewParams="title,search,body">
        <jsp:attribute name="title">
            <ul class="page-breadcrumb breadcrumb"> <li>
                    <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                    <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                </li>
                <li>
                    <span class="title2"><spring:message code="listPortAlerts.title"/></span>
                </li>
            </ul>

        </jsp:attribute>
        <jsp:attribute name="search">
        <div class="row" style="margin-bottom: 1em;">
            <label class="col-lg-1 control-label" style="top: 8px;" ><b><spring:message code="listIpReputation.value"/></b></label>
            <div class="col-lg-2">
                <input class="form-control"  id="portSearch" name="portSearch" placeholder="<spring:message code="addVulnerability.port"/>">
            </div>
            <div class="col-lg-6 right" style="float:right">
                <button type="button" onClick="refreshTable()" class="btn btn-primary right" id="search" style="float:right;margin-left:0.2em"><spring:message code="generic.search"/></button>
                <button type="button" onClick="clearInDiv()" class="btn btn-info right" id="clear" style="float:right"><spring:message code="generic.clear"/></button>      
            </div>
        </div>
        </jsp:attribute>
        <jsp:attribute name="script">
            <script type="text/javascript">
                document.title = "<spring:message code="listPortAlerts.title"/> - BIZZY";
                var oTable;
                oTable = $('#serverDatatables').dataTable({
                    "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "scrollX": true,
                    "serverSide": true,
                    "processing": true,
                    "stateSave": true,
                    "bFilter": false,
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
                    "searching": false,
                    "bLengthChange": true,
                    "stateSave": true,
                    "bInfo": true,
                    "order": [4, 'desc'],
                    "columnDefs": [ {
                                "targets": 5,
                                "data": "description",
                                render: function (data, type, row) {
                                var status = data.split(",")[2];
                                    if (status === 'UP' && status != null) {
                                        return '<button type="button" class="btn btn-danger btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="listPhishingResults.createTicket"/>"><i class="far fa-calendar"></i></button>';
                                    }
                                    else {
                                        return '<input type="hidden" class="editor-active" id="checkPortAlerts" value="'  + '" >';
                                    }
                                }
                                
                                
                        }
                    ],
                    "columns": [
                        {
                            data: "bizzyAlertId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkPortAlerts" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            data: "details",
                            render: function (data, type, row) {
                                var returnString = "";
                                for(var i=0;i<data.length;i++){
                                    returnString += data[i].detail.split(",")[1] + "<br>" + '<hr style="margin-bottom:0px;margin-top:0px;margin-right:-10px;border: none; border-bottom: 1px solid #e7ecf1;">';
                                }
                                return returnString;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            data: "details",
                            render: function (data, type, row) {
                                var returnString = "";
                                for(var i=0;i<data.length;i++){
                                    returnString += data[i].detail.split(",")[0] + "<br>" + '<hr style="margin-bottom:0px;margin-top:0px;margin-left:-10px;border: none; border-bottom: 1px solid #e7ecf1;">';
                                }
                                return returnString;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            data: "description",
                            render: function (data, type, row) {
                                var status = data.split(",")[2];
                                if(status != null) {
                                     return "Varlık keşfi taraması sonucunda portların " + status + " olduğu tespit edildi.";
                                } 
                               
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'createDate'}
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadPortAlerts.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}",
                                    d.portSearch = $('#portSearch').val();
                        },
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listCategories.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    }
                });
                
                $('#serverDatatables tbody').on( 'click', 'button', function () {
                            var row = $(this).closest("tr");
                            var table = row.closest('table').dataTable();
                            var rowData = table.api().row( row ).data();
                            var ips = new Map();
                            var str;
                            for(i = 0 ; i < rowData.details.length; ++i) {
                                var arr = rowData.details[i].detail.split(',');
                                if(ips.has(arr[0])) {
                                    ips.get(arr[0]).push(arr[1]);
                                } else {
                                    var portarray = [];
                                    var character = " | ";
                                    ips.set(arr[0], portarray);
                                    ips.get(arr[0]).push( "" + character + arr[1]);
                                }
                            }
                            var combined = "";
                            const array = Array.from(ips);
                            for(i = 0 ; i < array.length; ++i) {
                                combined += array[i]  +   "\n" ;
                            }
                            combined += "\n";
                            var createDate = <c:out value = "rowData.createDate"/>;
                            var descStr = "";
                            descStr += "<spring:message code="listAssets.asset"/>" + " | <spring:message code="generic.ports"/> : \n"  +combined+ "<spring:message code="listPortAlerts.ticketDesc"/>" +"\n";
                            descStr += "<spring:message code="listVulnerabilities.creationDate"/>: "+createDate+"\n";
                            $("#ticketName").val('<spring:message code="listPortAlerts.ticketName"/>');
                            $("#ticketDescription").val(descStr);
                            $("#createTicketModal").modal();
                       
                 });

                function deleteAlert() {
                    var alertIds = [];
                    $('input[id=checkPortAlerts]:checked').each(function () {
                        alertIds.push($(this).val());
                    });
                    $.post("deleteAlert.json", {
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
                
            
            function refreshTable(){
                    oTable.api().ajax.reload();
            }
            function clearInDiv() {
                $("#assetSearch").val("");
            }
            </script> 
            <jsp:include page="../tool/jsInformationOkCancelModal.jsp" /> 
            <jsp:include page="/WEB-INF/jsp/ti/include/ticketModal.jsp" />
                   
      
             
        </jsp:attribute>
        <jsp:body>
            <div class="row" style="margin-top:-25px ">
                <div class="col-lg-6">
                    <a class="btn btn-danger btn-info btn-sm" onclick="deleteAlert()" ><spring:message code="generic.delete"/></a>
                    <p></p>
                </div>
            </div>
            <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                <thead class="datatablesThead">
                    <tr>
                        <th width="10px"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('checkPortAlerts');"></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="addVulnerability.port"/></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="listAssets.asset"/></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="listVulnerabilities.status"/></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="listVulnerabilities.creationDate"/></th>
                        <th style="min-width: 100px; width: 100px;" width="100px" class="sorting_disabled" rowspan="1" colspan="1" aria-label=" "> </th>
                    </tr>
                </thead>                                
            </table>
            <style>
                .dataTables_length {
                    margin-top: 0px !important;
                    display: inline;
                    position: relative;
                    float: right;
                    z-index: 2;
                }
                .dataTables_wrapper{
                   margin-top: -48px;
                }
            </style>
        </jsp:body>
    </biznet:mainPanel>
</body>
</html>
