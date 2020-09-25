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
        <title>Risk Skoru Alarmı</title>
    </head>
    <biznet:mainPanel viewParams="title,body">
        <jsp:attribute name="title">
            <ul class="page-breadcrumb breadcrumb"> <li>
                    <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                    <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                </li>
                <li>
                    <span class="title2"><spring:message code="listRiskScoreAlerts.title"/></span>
                </li>
                <li>
                    <i class="fas fa-info-circle" aria-hidden="true" data-toggle="tooltip" data-placement="right" title="Risk skorunda önceki güne göre kritik bir artış olması durumunda üretilen alarmdır." ></i>
                </li> 
            </ul>

        </jsp:attribute>
        <jsp:attribute name="script">     
            <script type="text/javascript">
                document.title = "<spring:message code="listRiskScoreAlerts.title"/> - BIZZY";
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
                    "columns": [
                        {
                            data: "bizzyAlertId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkRiskScoreAlerts" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        }, {
                            data: "description",
                            render: function (data, type, row) {
                                var result = decodeHtml(data).split("|");
                                return result[0];
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            data: "description",
                            render: function (data, type, row) {
                                var result = decodeHtml(data).split("|");
                                return result[1];
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            data: "description",
                            render: function (data, type, row) {
                                var result = decodeHtml(data).split("|");
                                return result[2];
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'createDate'}
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadRiskScoreAlerts.json",
                        "data": function (d) {
                            d.resultId = "${resultId}",
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

                function deleteAlert() {
                    var alertIds = [];
                    $('input[id=checkRiskScoreAlerts]:checked').each(function () {
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

            </script>  
            <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />  
        </jsp:attribute>
        <jsp:attribute name="button">
            <div class="alert alert-danger">
                <spring:message code="listRiskScoreAlerts.Message"></spring:message>
            </div>
            <div class="portlet-body">
                <p>
                    <a class="btn btn-danger btn-info btn-sm" onclick="deleteAlert()" ><spring:message code="generic.delete"/></a>
                </p> 
            </div>
        </jsp:attribute>
        <jsp:body>
            <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                <thead class="datatablesThead">
                    <tr>
                        <th width="10px"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('checkRiskScoreAlerts');"></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="score.title"/></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="previousDayScore.title"/></th>
                        <th style="vertical-align: middle;width: 25%"><spring:message code="increaseRate.title"/></th>      
                        <th style="vertical-align: middle;width: 25%"><spring:message code="listVulnerabilities.creationDate"/></th>
                    </tr>
                </thead>                                
            </table>
            <style>
                .dt-buttons {
                    margin-top: 0% !important;
                    display: inline;
                    position: inherit !important;
                    z-index: 1;
                    left: 6%;
                    float: none !important;
                } 
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
