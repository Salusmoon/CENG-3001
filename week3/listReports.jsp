<%-- 
    Document   : listReports
    Created on : Mar 8, 2019, 5:39:40 PM
    Author     : gurkan.gezgen
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>

<!DOCTYPE html>
<biznet:mainPanel viewParams="title,body">
    
    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="main.theme.listReports"/></span>
            </li>
        </ul>
    </jsp:attribute>
    
    <jsp:attribute name="button">

        <sec:authorize access="!hasRole('ROLE_PENTEST_USER')" >
        <div class="portlet-body" style="margin-top: -2%">
            <div class="dt-buttons">
            
                <button onClick="deleteReports();" name="delete" type="button" class="btn btn-danger btn-sm"><spring:message code="listAssets.delete"/></button>
                
            </div>
        </div>
        </sec:authorize>
        


    </jsp:attribute>
    
    <jsp:attribute name="script">
          <style>
         
            
           #reportTable_processing
           {
            margin-top: -5%;      
            z-index: 1200;              
           }
        </style>
        <script type="text/javascript">
            document.title = "<spring:message code="main.theme.listReports"/> - BIZZY";
            var oTable;
            oTable = $('#reportTable').dataTable({//Etiketler
                "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                "processing": true,
                "serverSide": true,
                "searching": false,
                "stateSave": true,
                "scrollX": true,
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
                "columns": [
                    {"data": function (data, type, dataToSet) {
                            if(data.reportStatus !== 'NEW') {
                                return '<input type="checkbox" id="selectedReport" style="display:block; margin:0 auto; vertical-align:middle; " value="' + data.reportId + '" >';
                            } else {
                                return '';
                            }
                        },
                        "searchable": false,
                        "orderable": false
                    },
                    {"data": function (data) {
                            return data.reportName + "." + data.reportExtension;
                        }
                    },
                    {"data": 'reportStatus',
                        "searchable": false,
                        "orderable": false
                    },
                    {"data": 'createDate'},
                    {"data": 'createdBy'},
                    {"data": 'completionDate'},
                    {"data": 'reportType', "searchable": false, "orderable": false,
                        "render": function (data) {
                            switch (data) {
                                case "VULNERABILITY_REPORT" :
                                        return '<div><spring:message code="report.vulnReport"/></div>';
                                case "SCAN_REPORT" :
                                        return '<div><spring:message code="report.scanReport"/></div>';
                                case "ASSET_REPORT" :
                                        return '<div><spring:message code="report.assetReport"/></div>';
                                case "BDDK_REPORT" :
                                        return '<div><spring:message code="listScans.bddkReport"/></div>';
                                case "ASSET_CSV_REPORT" :
                                        return '<div><spring:message code="listAssets.report"/></div>';
                                case "WEEKLY_REPORT" :
                                        return '<div><spring:message code="report.weeklyReport"/></div>';
                                case "MANAGER_REPORT" :
                                        return '<div><spring:message code="report.managerReport"/></div>';
                                case "OWASP_REPORT" :
                                        return '<div><spring:message code="report.owaspReport"/></div>';
                                case "SSL_REPORT" :
                                        return '<div><spring:message code="report.sslReport"/></div>';
                                case "VULNERABILITY_MONTH_STATUS_REPORT" :
                                        return '<div><spring:message code="report.vulnMonthStatusReport"/></div>';
                                case "VULNERABILITY_MONTH_REPORT" :
                                        return '<div><spring:message code="report.vulnMonthReport"/></div>';
                                case "VULNERABILITY_ASSET_REPORT" :
                                        return '<div><spring:message code="report.vulnAssetReport"/></div>';
                                case "VULNERABILITY_ROOT_CAUSE_REPORT" :
                                        return '<div><spring:message code="report.vulnRootCauseReport"/></div>';
                                case "VULNERABILITY_CATEGORY_REPORT" :
                                        return '<div><spring:message code="report.vulnCategoryReport"/></div>';
                                default :
                                        return '<div></div>';
                            }
                        }
                    },
                    {"data": function (data, type, dataToSet) {
                            var html = "";
                            if(data.reportDataId !== null) {
                                html = '<a class ="btn btn-info btn-sm" data-toggle="tooltip" data-placement ="top" title ="<spring:message code="generic.download"/>" onclick="downloadReport(\'' + data.reportId + '\')"> <i class=" fas fa-download" aria-hidden="true"></i></a> ';
                                html += '<a class ="btn btn-success btn-sm" data-toggle="tooltip" data-placement ="top" title ="<spring:message code="generic.detail"/>" onclick="showModal(\'' + data.reportId + '\')"><i class="fas fa-info-circle"></i></a> ';
                                }
                            return html;
                        },
                        "searchable": false,
                        "orderable": false
                    },       
                ],
                "order": [3, 'desc'],
                "ajax": {
                    "type": "POST",
                    "url": "loadReports.json",
                    "data": function (d) {
                                d.${_csrf.parameterName} = "${_csrf.token}";
                    },
                    // error callback to handle error
                    "error": function (jqXHR, textStatus, errorThrown) {
                        console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listQualysScans.tableError"/>");
                        $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                        $("#alertModal").modal("show");
                    }
                },
                "createdRow": function (row, data, index) {
                    var statusRow = "2";
                    var status = decodeHtml(data.reportStatus);
                    switch (status) {
                    case "NEW" :
                            $('td', row).eq(statusRow).wrapInner('<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="report.reportNew"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/oval.svg" width="25"/></div>');
                    break;
                case "COMPLETED" :
                            $('td', row).eq(statusRow).wrapInner('<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="report.reportCompleted"/>"  style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/check.svg" width="25"/></div>');
                    break;
                    case "FAILED" :
                            $('td', row).eq(statusRow).wrapInner('<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="report.reportFailed"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>');
                    break;
                    default :
                            $('td', row).eq(statusRow).wrapInner('<div></div>');
                    break;
                    }
                },
                "fnDrawCallback": function (oSettings) {
                    $('[data-toggle="tooltip"]').tooltip();
                },
                "initComplete": function (settings, json) {
                    $('[data-toggle="tooltip"]').tooltip();
                }
            });           
            function deleteReports() {
                function confirmDelete(){

                    var reportIds = [];
                    $('[id=selectedReport]:checked').each(function () {
                        reportIds.push($(this).val());
                    });
                    $.post("deleteReports.json", {
                        'reportIds': reportIds, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function () {
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }).always(function () {
                        oTable.fnDraw();
                    });
                }

                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listKBItems.confirmDelete"/>"), confirmDelete);
            }
        </script>
    </jsp:attribute>
        
    <jsp:body>
        <jsp:include page="include/viewReportDetailModal.jsp" />
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        <table class="table table-striped table-bordered table-hover" width="100%" id="reportTable"  >

            <thead class="datatablesThead">
                <tr>
                    <th style="vertical-align: middle; max-width: 20px; min-height: 42px;"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('selectedReport');" ></th>
                    <th style="vertical-align: middle; min-width: 350px; min-height: 42px;"><spring:message code="reviewReport.reportName"/></th>
                    <th style="vertical-align: middle; max-width: 100px; min-height: 42px;"><spring:message code="listVulnerabilities.reportStatus"/></th>
                    <th style="vertical-align: middle; min-width: 100px; min-height: 42px;"><spring:message code="reviewReport.createDate"/></th>
                    <th style="vertical-align: middle; min-width: 100px; min-height: 42px;"><spring:message code="reviewReport.createdBy"/></th>
                    <th style="vertical-align: middle; max-width: 150px; min-height: 42px;"><spring:message code="listScans.completionDate"/></th>
                    <th style="vertical-align: middle; min-width: 150px; min-height: 42px;"><spring:message code="report.reportType"/></th>
                    <th style="vertical-align: middle; max-width: 32px; min-height: 42px;"></th>
                    <%-- <th style="vertical-align: middle; max-width: 32px; min-height: 42px;"></th> --%>
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
                margin-top: 0px;
                display: inline;
                position: relative;
                float: right;
                z-index: 2;
                margin-right: -10px;
            }
            .dataTables_wrapper{
               margin-top: -48px;
            }
        </style>
    </jsp:body>

</biznet:mainPanel>
