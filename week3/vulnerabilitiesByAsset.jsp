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
        <title>Bulguların Varlıklara Göre Dağılımı</title>
    </head>
    <biznet:mainPanel viewParams="title,search,body">
        <jsp:attribute name="title">
            <ul class="page-breadcrumb breadcrumb"> <li>
                    <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                    <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                </li>
                <li>
                    <span class="title2"><spring:message code="vulnerabilitiesByAsset.title"/></span>
                </li>
            </ul>

        </jsp:attribute>
        <jsp:attribute name="search">
            <jsp:include page="/WEB-INF/jsp/customer/include/vulnerabilitySearchpanel.jsp" >
                <jsp:param name="type" value="vulnerabilityByAsset"/>  
            </jsp:include>   
        </jsp:attribute>
        <jsp:attribute name="script">
            <script type="text/javascript">
                document.title = "<spring:message code="vulnerabilitiesByAsset.title"/> - BIZZY";
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
                            "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                            "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                            "processing": "<spring:message code="generic.tableLoading"/>",
                            "infoEmpty":  "<spring:message code="generic.tableInfo" arguments="${'0'},${'0'},${'0'}"/>"
                        },

                        "columns": [
                            {"data": 'vulnerability.name',
                                "searchable": false,
                                "orderable": false},
                            {"data": 'vulnerability.riskLevel',
                                "searchable": false,
                            },
                            {"data": 'vulnerability.asset.ip',
                                "searchable": false,
                                "orderable": false
                            },
                            {"data": 'assetCount',
                                "searchable": false
                            }
                        ],
                        "order": [1, 'desc'],
                        "ajax": {
                            "type": "POST",
                            "url": "loadVulnerabilitiesByAsset.json",
                            "data": function (obj) {
                                var tempObj = getObjectByForm("searchForm");
                                Object.keys(tempObj).forEach(function (key) {
                                    obj[key] = tempObj[key];
                                });
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
                        },
                        "createdRow": function (row, data, index) {
                            var service = "1";
                            switch (data.vulnerability['riskLevel'].toString()) {
                                case "0" :
                                    $('td', row).eq(service).wrapInner('<div class="riskLevel0 riskLevelCommon"></div>');
                                    break;
                                case "1" :
                                    $('td', row).eq(service).wrapInner('<div class="riskLevel1 riskLevelCommon"></div>');
                                    break;
                                case "2" :
                                    $('td', row).eq(service).wrapInner('<div class="riskLevel2 riskLevelCommon"></div>');
                                    break;
                                case "3" :
                                    $('td', row).eq(service).wrapInner('<div class="riskLevel3 riskLevelCommon"></div>');
                                    break;
                                case "4" :
                                    $('td', row).eq(service).wrapInner('<div class="riskLevel4 riskLevelCommon"></div>');
                                    break;
                                case "5" :
                                    $('td', row).eq(service).wrapInner('<div class="riskLevel5 riskLevelCommon"></div>');
                                    break;
                            }
                        }
                    });
                });

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
                    var tempObj = getObjectByForm("searchForm");
                    Object.keys(tempObj).forEach(function (key) {
                        obj[key] = tempObj[key];
                    });
                    obj["reportName"] = $('#reportName').val();
                    obj["reportType"] = $('#reportType').val();
                    generateReport("getVulnerabilitiesByAssetReport.json", obj, "<spring:message code="report.reportCreation"/>", 
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

                $('#daterange').daterangepicker({
                    autoUpdateInput: false,
                    locale :  <c:choose>
                            <c:when test="${language == 'tr'}">
                                 <c:out value = "turkish_daterangepicker"/>
                            </c:when>
                            <c:otherwise>
                                <c:out value = "english_daterangepicker"/>
                            </c:otherwise>                        
                        </c:choose>
                });

                $('#daterange').on('apply.daterangepicker', function (ev, picker) {
                    $(this).val(picker.startDate.format('DD.MM.YYYY') + '-' + picker.endDate.format('DD.MM.YYYY'));
                });
                $('#daterange').on('cancel.daterangepicker', function (ev, picker) {
                    $(this).val('');
                });

            </script>  
              <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        </jsp:attribute>
        <jsp:body>
            <a class="btn btn-primary btn-sm" onclick="getAReport()"><spring:message code="listAssets.getAssesmentReport"/></a>
            <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                <thead class="datatablesThead">
                    <tr>
                        <th style="vertical-align: middle;width: 60%"><spring:message code="vulnerability.name"/></th>
                        <th style="vertical-align: middle;width: 10%"><spring:message code="vulnerability.riskLevel"/></th>
                        <th style="vertical-align: middle;width: 20%"><spring:message code="listAssets.title"/></th>
                        <th style="vertical-align: middle;width: 10%"><spring:message code="listAssetGroups.assetsCount"/></th>
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
</body>
</html>
