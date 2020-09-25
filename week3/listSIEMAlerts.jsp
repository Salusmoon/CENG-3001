<%-- 
    Document   : listSIEMAlerts
    Created on : 19-Dec-2018, 13:42:17
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SIEM Alarmı</title>
    </head>
    <body>
        <biznet:mainPanel viewParams="title,body">
            <jsp:attribute name="title">
                <ul class="page-breadcrumb breadcrumb"> <li>
                        <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                        <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                    </li>
                    <li>
                        <span class="title2"><spring:message code="listSIEMAlerts.title"/></span>
                    </li>
                </ul>

            </jsp:attribute>
            <jsp:attribute name="script">
                <script type="text/javascript">
                    document.title = "<spring:message code="listSIEMAlerts.title"/> - BIZZY";
                    var oTable;
                    oTable = $('#serverDatatables').dataTable({
                        "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                        "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                        "scrollX": true,
                        "processing": true,
                        
                 
                       
                        
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
                        "order": [0, 'desc'],
                        "columns": [
                            {"data": 'createDate'},
                            {"data": "alert"},
                            {"data": 'destination'},
                            {"data": 'destionationHost'},
                            {"data": 'source'},
                            {"data": 'sourceHost'},
                            {"data": 'priority'},
                            {"data": 'agent'}
                        ],
                        "ajax": {
                            "type": "POST",
                            "url": "loadSIEMAlerts.json",
                            "data": function (d) {
                                d.${_csrf.parameterName} = "${_csrf.token}";
                            },
                            "error": function (jqXHR, textStatus, errorThrown) {
                                console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listCategories.tableError"/>");
                                $("#alertModal").modal("show");
                            }
                        },
                        "initComplete": function (settings, json) {
                            $('[data-toggle="tooltip"]').tooltip();
                        }
                    });

                </script> 
                  <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
            </jsp:attribute>
            <jsp:body>
                <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                    <thead class="datatablesThead">
                        <tr>
                            <th style="vertical-align: middle;width: 10%"><spring:message code="listNetworkAssets.date"/></th>
                            <th style="vertical-align: middle;width: 25%"><spring:message code="siem.alert"/></th>
                            <th style="vertical-align: middle;width: 10%"><spring:message code="startScan.target"/> IP</th>
                            <th style="vertical-align: middle;width: 10%"><spring:message code="startScan.target"/> Host</th>
                            <th style="vertical-align: middle;width: 10%"><spring:message code="listScans.source"/> IP</th>
                            <th style="vertical-align: middle;width: 10%"><spring:message code="listScans.source"/> Host</th>
                            <th style="vertical-align: middle;width: 5%"><spring:message code="dashboard.alarmLevel"/></th>
                            <th style="vertical-align: middle;width: 25%"><spring:message code="generic.tool"/></th>
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
                </style>
            </jsp:body>
        </biznet:mainPanel>
    </body>
</html>