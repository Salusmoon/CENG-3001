<%-- 
    Document   : vulnerabilitiesByRootCause
    Created on : Jul 17, 2018, 9:51:45 AM
    Author     : iremkaraoglu
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<biznet:mainPanel viewParams="title,body">
    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="dashboard.rootvulnerabilities"/></span>
            </li>
        </ul>

    </jsp:attribute>
    <jsp:attribute name="script">
        <script type="text/javascript">
            document.title = "<spring:message code="dashboard.rootvulnerabilities"/> - BIZZY";
            var oTable;
            $(document).ready(function () {
                oTable = $('#serverDatatables').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "stateSave": true,
                    "scrollX": true,
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

                    "columns": [
                        {
                            "className": 'details-extend',
                            "orderable": false,
                            "data": null,
                            "defaultContent": ''
                        },
                        {"data": 'name',
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'count',
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'totalCount',
                            "searchable": false,
                            "orderable": false
                        }
                    ],

                    "ajax": {
                        "type": "POST",
                        "url": "loadRootCauseListWithVulnerabilities.json",
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
            });
            $('#serverDatatables').on('click', 'td.details-extend', function () {
                var tr = $(this).closest('tr');
                var row = oTable.api().row(tr);
                if (row.child.isShown()) {
                    row.child.hide();
                    tr.removeClass('shown');
                } else {
                    $.ajax({
                        type: "POST",
                        url: "loadVulnerabilitiesByRootCause.json",
                        "data": {
                            '${_csrf.parameterName}': "${_csrf.token}",
                            'rootCause': row.data().rootCause
                        },
                        success: function (result) {
                            row.child(format(result,row)).show();
                            tr.addClass('shown');
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                        }
                    });
                }
            });
            function format(detail,row) {
                var div1 = document.createElement("div");
                var div2 = document.createElement("div");
                div2.className = "col-lg-12";

                var table = document.createElement("table");
                table.id = "altTable" + row.data().id;
                table.className = "table blue-bordered";
                table.style.width = "100%";
                var tbody = document.createElement("tbody");
                var trHead = document.createElement("tr");
                var th1 = document.createElement("th");
                th1.style.verticalAlign = "middle";
                th1.style.width = "60%";
                th1.innerText = decodeHtml("<spring:message code="listVulnerabilities.vName"/>");
                trHead.appendChild(th1);
                var th2 = document.createElement("th");
                th2.style.verticalAlign = "middle";
                th2.style.width = "10%";
                th2.innerText = decodeHtml("<spring:message code="vulnerability.riskLevel"/>");
                trHead.appendChild(th2);
                var th3 = document.createElement("th");
                th3.style.verticalAlign = "middle";
                th3.style.width = "10%";
                th3.innerText = decodeHtml("<spring:message code="listScans.webAppCount"/>");
                trHead.appendChild(th3);
                var th4 = document.createElement("th");
                th4.style.verticalAlign = "middle";
                th4.style.width = "10%";
                th4.innerText = decodeHtml("<spring:message code="listScans.vulnCount"/>");
                trHead.appendChild(th4);
                tbody.appendChild(trHead);

                $.each(detail, function (i, val) {
                    var tr = document.createElement("tr");
                    tr.id = "red";
                    var td1 = document.createElement("td");
                    td1.innerText = decodeHtml(val.vulnerability.name);
                    tr.appendChild(td1);
                    var td2 = document.createElement("td");
                    var div = document.createElement("div");
                    div.className = "riskLevel" + decodeHtml(val.vulnerability.riskLevel) + " riskLevelCommon";
                    div.innerText = decodeHtml(val.vulnerability.riskLevel);
                    td2.appendChild(div);
                    tr.appendChild(td2);
                    var td3 = document.createElement("td");
                    td3.innerText = decodeHtml(val.vulnerability.count);
                    tr.appendChild(td3);
                    var td4 = document.createElement("td");
                    td4.innerText = decodeHtml(val.vulnerability.totalCount);
                    tr.appendChild(td4);
                    tbody.appendChild(tr);
                });

                table.appendChild(tbody);
                div2.appendChild(table);
                div1.appendChild(div2);

                return div1;
            }
            function getAReport() {
                    $('#report').modal('show');
            }
            function closeReportModal() {
                $('#reportName').val("");
                $('#reportType').val('<spring:message code="listVulnerabilities.pdf"/>');
                document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                document.getElementById("statusErrorTag").style.visibility = "hidden";
                $('#report').modal('hide');
            }

            function reportNameControl(){
                var text = document.getElementById("reportName");
                if (!text.value || text.value.length === 0) {
                document.getElementById("statusErrorTag").style.visibility = "visible";
                //return 'fail';
                } else {
                var obj = {};
                obj["${_csrf.parameterName}"] = "${_csrf.token}";
                obj["reportName"] = $('#reportName').val();
                obj["reportType"] = $('#reportType').val();
                generateReport("getVulnerabilitiesByRootCauseReport.json", obj, "<spring:message code="report.reportCreation"/>", 
                        "<spring:message code="listVulnerabilities.reportError"/>", "<spring:message code="listVulnerability.noData"/>");
                closeReportModal();
                }
            }
            function reportTypeChanged() {
                var reportType = document.getElementById("reportType").value;
                switch(reportType) {
                    case '<spring:message code="listVulnerabilities.pdf"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                        break;
                    case '<spring:message code="listVulnerabilities.csv"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.csv</b>';
                        break;
                    default:
                        document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                        break;
                }
            }


        </script>
          <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        <style>
            tr.group,
            tr.group:hover {
                background-color: #ddd !important;
            }
        </style>
    </jsp:attribute>
    <jsp:body>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/taskengine.min.css">
        <a class="btn btn-primary btn-sm" onclick="getAReport()"><spring:message code="listAssets.getAssesmentReport"/></a>
        <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
            <thead class="datatablesThead">
                <tr>
                    <th style="width:3%;"></th>
                    <th style="vertical-align: middle; width:60%"><spring:message code="addCategory.rootCause"/></th>
                    <th style="vertical-align: middle; width:10%"><spring:message code="listScans.webAppCount"/></th>
                    <th style="vertical-align: middle; width:10%"><spring:message code="listScans.vulnCount"/></th>
                </tr>
            </thead>                                
        </table>
        <div class="modal fade" id="report" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width:25%">
                <div class="modal-content">
                    <div class="modal-header">
                        <spring:message code="listReports.title"/>
                    </div>
                    <div class="modal-body">                       
                        <div class="panel-body"> 
                            <div class="form-group required">
                                <label><spring:message code="reviewReport.reportName"/></label>
                                <div style="display:flex;">
                                    <input class="form-control" id ="reportName" maxlength="50" style="width:80%;">
                                    <span id ="reportExtension" style="width:20%;line-height:3;margin-left:2px;"><b>.pdf</b></span>   
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="listVulnerabilities.reportType"/></label>
                                <select id="reportType" class="selectpicker btn btn-sm btn-default btn-info dropdown-toggle" onchange="reportTypeChanged();" data-style="btn btn-info btn-sm">
                                    <option value='<spring:message code="listVulnerabilities.pdf"/>'><spring:message code="listVulnerabilities.pdf"/></option>
                                    <option value='<spring:message code="listVulnerabilities.csv"/>'><spring:message code="listVulnerabilities.csv"/></option>
                                </select>
                            </div>
                            <div class="form-group">
                                <p id="statusErrorTag" style="color:red;visibility:hidden">
                                    <br><b><spring:message code="report.reportNameValidation"/></b></p>        
                            </div>    
                            <br>
                            <div class="modal-footer" id="download">
                                <div class="row">
                                    <div class="row">
                                        <button type="buttonback" id="buttonback" onclick="closeReportModal();" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                        <button onClick="reportNameControl()" id="downloadReport" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>       
                </div>  
            </div>
        </div>
    </jsp:body>
</biznet:mainPanel>