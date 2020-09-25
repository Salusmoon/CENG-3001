<%-- 
    Document   : listVulnerabilities
    Created on : Mar 6, 2015, 5:28:24 PM
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<!DOCTYPE html>
<biznet:mainPanel viewParams="title,search,searchBox,body">
    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listVulnerabilities.vulnerabilities"/></span>
            </li>
        </ul>
    </jsp:attribute>

    <jsp:attribute name="search">
        <jsp:include page="/WEB-INF/jsp/customer/include/vulnerabilitySearchpanel.jsp" >
            <jsp:param name="type" value="vulnerability"/>
        </jsp:include>
    </jsp:attribute>

    <jsp:attribute name="alert">
        <c:if test="${not empty status}">
            <div class="alert alert-warning">
                <spring:message code="${status}"></spring:message>
                </div>
        </c:if>
    </jsp:attribute>

    <jsp:attribute name="button">
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_REPORTER,ROLE_PENTEST_ADMIN')" >
            <c:if test="${not empty assetId}">
                <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                    <a style="display: none" class="btn btn-primary btn-sm" href="addVulnerability.htm?assetId=<c:out value="${assetId}" />">
                        <spring:message code="listVulnerabilities.addVulnerability"/></a>  
                    </sec:authorize>
                </c:if>
            </sec:authorize>
            <sec:authorize access = "!hasRole('ROLE_PENTEST_ADMIN')">
                <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED, ROLE_PENTEST_USER')" >
                    <c:if test="${empty assetId}">
                    <div class="btn-group">
                        <a class="btn btn-sm btn-default btn-info dropdown-toggle" onclick='openReportTypeModal()' aria-expanded="false"> 
                            <spring:message code="listAssets.getAssesmentReport"/>
                        </a>
                    </div>
                </c:if>
            </sec:authorize>    
        </sec:authorize>
        <sec:authorize access = "!hasAnyRole('ROLE_PENTEST_ADMIN','ROLE_COMPANY_SSL')">
            <sec:authorize access = "!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                <div class="btn-group">
                    <a class="btn btn-sm btn-default btn-success dropdown-toggle" data-toggle="dropdown" href="javascript:;" aria-expanded="false"> 
                        <spring:message code="listVulnerabilities.actions"/>
                        <i class="fas fa-angle-down"></i>
                    </a>
                    <ul class="dropdown-menu">    
                        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                            <li id="updateAssigneeOption">
                                <a onclick="showActionModals('1')"> <spring:message code="listVulnerabilities.updateAssignee"/> </a>
                            </li>
                        </sec:authorize>
                        <li>
                            <a onclick="showActionModals('2')"> <spring:message code="listVulnerabilities.updateStatus"/> </a>
                        </li>
                        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') and !hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED') or hasRole('ROLE_COMPANY_MANAGER')">
                            <li id="updateStatusOption">
                                <a onclick="showActionModals('4')"> <spring:message code="listVulnerabilities.updateVulnerabilities"/> </a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
                            <li id="groupTitleOption">
                                <a onclick="groupSelectedVulnerabilities();"><spring:message code="listVulnerabilities.groupTitle"/></a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') and !hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED') or hasRole('ROLE_COMPANY_MANAGER')">
                            <li id="deleteOption">
                                <a onclick="showActionModals('3')"> <spring:message code="generic.delete"/> </a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') and !hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED') or hasRole('ROLE_COMPANY_MANAGER')">
                            <li id="archivedOption">
                                <a onclick="showActionModals('6')"> <spring:message code="generic.archive"/> </a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                            <li id="downloadProofsOption">
                                <a onclick="showActionModals('5')"><spring:message code="listVulnerabilities.downloadProofs"/></a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
                            <c:if test="${sendToScan}">
                            <li id="scanVulnerabilitiesOption">
                                <a onclick="openVulnerabilityScanModal()"><spring:message code="listVulnerabilities.scanVulnerabilities"/></a>
                            </li>
                            </c:if>
                        </sec:authorize>    
                    </ul>
                </div>
            </sec:authorize>
        </sec:authorize>
        <jsp:include page="../customer/include/reportGraph.jsp" />
    </jsp:attribute>


    <jsp:attribute name="script">
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        <script type="text/javascript">
            document.title = "<spring:message code="listVulnerabilities.vulnerabilities"/> - BIZZY";
            var reportNameControl;
            $("[data-toggle=popover]").popover();
            function showSearchDiv(divID) {
                var div = document.getElementById(divID);
                var searchBoxDiv = document.getElementById("searchBoxDiv");
                if (div.style.display === 'none') {
                    div.style.display = 'block';
                    $('#searchBox').val('');
                    searchBoxDiv.style.display = 'none';
                } else {
                    div.style.display = 'none';
                    searchBoxDiv.style.display = 'block';
                }
            }
            $("input:checkbox").on('click', function() {
                var $box = $(this);
                if ($box.is(":checked")) {
                  var group = "input:checkbox[name='" + $box.attr("name") + "']";
                  $(group).prop("checked", false);
                  $box.prop("checked", true);
                } else {
                  $box.prop("checked", false);
                }
            });
            $(document).ready(function () {
                reportNameControl = function () {
                    var text = document.getElementById("reportName");

                    if (!text.value || text.value.length === 0) {
                        document.getElementById("reportErrorPTag").style.visibility = "visible";
                        //return 'fail';
                    } else {
                        document.getElementById("reportErrorPTag").style.visibility = "hidden";
                        redirectReport();
                        // return 'success';
                    }
                }
                $('[data-toggle="tab"]').tooltip({
                        placement: 'top',
                        trigger: 'hover',
                        delay:    '500'
                });
                function redirectReport() {
                    blockUILoading();
                    var params = getObjectByForm("searchForm");
                    params["newVulnerabilities"] = newVulnerabilities;
                    params["searchBox"] = $('#searchBox').val();
                    params["reportExtension"] = $('#reportType').val();
                    params["reportName"] = $('#reportName').val();
                    params["currentTab"] = currentTab;
                    params["statusGraphData"] = "";
                    params["riskLevelGraphData"] = "";
                    params["assetLevelGraphData"] = "";
                    params["isPCIReport"] = $("#isPCIReport").is(':checked');
                    params["isTicketReport"] = $("#isTicketReport").is(':checked');
                    if ($('#reportType').val() === '<spring:message code="listVulnerabilities.pdf"/>') {
                        statusGraph.exporting.getImage("png").then(function (response) {
                            params["statusGraphData"] = response;
                        });
                        riskLevelGraph.exporting.getImage("png").then(function (response) {
                            params["riskLevelGraphData"] = response;
                        });
                        assetLevelGraph.exporting.getImage("png").then(function (response) {
                            params["assetLevelGraphData"] = response;
                        });
                        setTimeout(function () {
                            generateReport("getAssesmentReport.json", params, "<spring:message code="report.reportCreation"/>",
                                    "<spring:message code="listVulnerabilities.reportError"/>", "<spring:message code="listVulnerability.noData"/>");
                            unBlockUILoading();
                        }, 10000);
                    } else {
                        generateReport("getAssesmentReport.json", params, "<spring:message code="report.reportCreation"/>",
                                "<spring:message code="listVulnerabilities.reportError"/>", "<spring:message code="listVulnerability.noData"/>");
                        unBlockUILoading();
                    }
                    closeReportTypeModal();
                }
                getVulCounts();
                $('#allVulnTable').on('load', loadAllVulnTable());
            });
            var labelsAndColors = [];
            var labelsList = [];
            var colors = [];
            var filterStatuses = [];
            var filterSources = [];
            var filterRiskLevels = [];
            var filterAssetGroups = [];
            var filterAssetGroups = [];
            var filterScans = [];
            var stats = [];
            var assigneeValues =[];
            <c:forEach var="item" items="${labelList}">
            colors.push("default");
            colors.push("info");
            colors.push("success");
            colors.push("warning");
            colors.push("primary");
            colors.push("danger");
            </c:forEach>
            <c:forEach var="item" items="${labelList}">
            labelsAndColors.push('<h4><span class="label label-' + colors.pop() + '">' + '<c:out value="${item.name}"/>' + '</span></h4>');
            labelsList.push(decodeHtml('<c:out value="${item.name}"/>'));
            </c:forEach>
            //index'den gelen filtreler
            <c:forEach var="item" items="${filterStatuses}">
            filterStatuses.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>
            <c:forEach var="item" items="${filterSources}">
            filterSources.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>
            <c:forEach var="item" items="${filterRiskLevels}">
            filterRiskLevels.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>
            <c:forEach var="item" items="${filterAssetGroups}">
            filterAssetGroups.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>
            <c:forEach var="item" items="${filterScans}">
            filterScans.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>

            <c:forEach var="item" items="${statusValues}">
            stats.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>
            <c:forEach var="item" items="${assigneeValue}">
            assigneeValues.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>

            var newVulnerabilities;

            var chartdiv;
            var chartdiv2;

            $('#statuses').val(filterStatuses).trigger("change");
            $('#source').val(filterSources).trigger("change");
            $('#riskLevels').val(filterRiskLevels).trigger("change");
            $('#groups').val(filterAssetGroups).trigger("change");
            $('#scan').val(filterScans).trigger("change");

            if ('<c:out value="${level}"/>'.length === 1) {
                $("#riskLevels").val(decodeHtml('<c:out value="${level}"/>')).trigger('change');
            }
            if ('<c:out value="${riskScore}"/>'.length > 0) {
                var riskScore = decodeHtml('<c:out value="${riskScore}"/>');
                var reg = new RegExp('^\\d+\\s-\\s\\d+$', 'gm');
                if (reg.test(riskScore)) {
                    var values = riskScore.split(' - ');
                    if (parseInt(values[0]) >= 0 && parseInt(values[1]) <= 100 && parseInt(values[0]) < parseInt(values[1])) {
                        $("#riskScoreRange").val(riskScore);
                    }
                } else {
                    $("#riskScoreRange").val('0 - 100');
                }
                var riskScoreVal = $("#riskScoreRange").val();
                var riskScoreRange = riskScoreVal.split(' - ');
                $("#riskScoreSlider").slider('values', 0, riskScoreRange[0]);
                $("#riskScoreSlider").slider('values', 1, riskScoreRange[1]);
            }
            if (stats.length > 0) {
                $("#statuses").val(stats).trigger('change');
            }
            if ("${labelList}".length > 0) {
                $("#labels").val("${labelList}").trigger('change');
            }
            if ("${groupId}".length > 0) {
                if ("${groupId}" === 'group') {
                    $("#groups").val("NULL").trigger('change');
                } else {
                    $("#groups").val("${groupId}").trigger('change');
                }
            }
            if ('<c:out value="${effectValue}"/>'.length > 0) {
                if ('<c:out value="${effectValue}"/>' === 'effect') {
                    $("#effect").val("NULL").trigger('change');
                } else {
                    $("#effect").val(decodeHtml('<c:out value="${effectValue}"/>')).trigger('change');
                }
            }
            if ('<c:out value="${rootCauseValue}"/>'.length > 0) {
                if ('<c:out value="${rootCauseValue}"/>' === 'rootCause') {
                    $("#rootCause").val("NULL").trigger('change');
                } else {
                    $("#rootCause").val(decodeHtml('<c:out value="${rootCauseValue}"/>')).trigger('change');
                }
            }
            if ('<c:out value="${categoryValue}"/>'.length > 0) {
                if ('<c:out value="${categoryValue}"/>' === 'category') {
                    $("#categories").val("NULL").trigger('change');
                } else {
                    $("#categories").val(decodeHtml('<c:out value="${categoryValue}"/>')).trigger('change');
                }
            }
            if ('<c:out value="${problemAreaValue}"/>'.length > 0) {
                if ('<c:out value="${problemAreaValue}"/>' === 'problemArea') {
                    $("#problemArea").val("NULL").trigger('change');
                } else {
                    $("#problemArea").val(decodeHtml('<c:out value="${problemAreaValue}"/>')).trigger('change');
                }
            }
            if ('<c:out value="${assigneeValue}"/>'.length > 0) {
                if ('<c:out value="${assigneeValue}"/>' === 'assignee') {
                    $("#filterAssigneeId").val("NULL").trigger('change');
                } else {
                    $("#filterAssigneeId").val(assigneeValues).trigger('change');
                }
            }
            if ('<c:out value="${vulnerabilityName}"/>'.length > 0) {
                $("#vulnName").val(decodeHtml('<c:out value="${vulnerabilityName}"/>'));
            }
            if ('<c:out value="${portValue}"/>'.length > 0) {
                $("#port").val(decodeHtml('<c:out value="${portValue}"/>'));
            }
            if ("${date}".length > 0) {
                newVulnerabilities = "${date}";
            }

            var totalVulnerabiliteslink = localStorage.getItem("clicked");

            if (totalVulnerabiliteslink === "true") {
                $("#riskLevels").val([1, 2, 3, 4, 5]).trigger('change');
                $("#statuses").val(["OPEN", "RISK_ACCEPTED", "RECHECK", "ON_HOLD", "IN_PROGRESS", "FALSE_POSITIVE"]).trigger('change');
                localStorage.setItem("clicked", "false");
            }

            function allRecordsFunction() {
                if ($('#selectAll').is(":checked")) {
                    $('#allRecords').show();
                } else {
                    $('#allRecords').hide();
                    $("#checkBoxAllRecords").prop('checked', false);
                }
            }
            function allRecords2Function() {
                if ($('#selectAll2').is(":checked")) {
                    $('#allRecords').show();
                } else {
                    $('#allRecords').hide();
                    $("#checkBoxAllRecords").prop('checked', false);
                }
            }
            function allRecords3Function() {
                if ($('#selectAll3').is(":checked")) {
                    $('#allRecords').show();
                } else {
                    $('#allRecords').hide();
                    $("#checkBoxAllRecords").prop('checked', false);
                }
            }
            function allRecords4Function() {
                if ($('#selectAll4').is(":checked")) {
                    $('#allRecords').show();
                } else {
                    $('#allRecords').hide();
                    $("#checkBoxAllRecords").prop('checked', false);
                }
            }

            function createFilterData() {
                return $("#searchForm").serializeArray();
            }

            var url = window.location.href;
            var assetPageOpened = {};
            if (url.indexOf("assetId") > -1 || url.indexOf("level") > -1 || url.indexOf("riskScore") > -1 || url.indexOf("statusValues") > -1 || url.indexOf("groupId") > -1
                    || url.indexOf("effectValue") > -1 || url.indexOf("vulnerabilityName") > -1 || url.indexOf("rootCauseValue") > -1 || url.indexOf("portValue") > -1
                    || url.indexOf("categoryValue") > -1 || url.indexOf("problemAreaValue") > -1 || url.indexOf("assigneeValue") > -1 || url.indexOf("new") > -1 || url.indexOf("AssigneeId") > -1) { 
                assetPageOpened = 1;
                showSearchDiv('collapseSearch');
            } else {
                loadLocalStorage("listVulnerabilities");
                var riskScoreVal = $("#riskScoreRange").val();
                var riskScoreRange = riskScoreVal.split(' - ');
                $("#riskScoreSlider").slider('values', 0, riskScoreRange[0]);
                $("#riskScoreSlider").slider('values', 1, riskScoreRange[1]);
            <c:if test="${sessionScope.performanceScoreActive}">   
                var performanceScoreVal = $("#performanceScoreRange").val();
                var performanceScoreRange = performanceScoreVal.split(' - ');
                $("#performanceScoreSlider").slider('values', 0, performanceScoreRange[0]);
                $("#performanceScoreSlider").slider('values', 1, performanceScoreRange[1]);
                var vprScoreVal = $("#vprScoreRange").val();
                var vprScoreRange = vprScoreVal.split(' - ');
                $("#vprScoreSlider").slider('values', 0, vprScoreRange[0]);
                $("#vprScoreSlider").slider('values', 1, vprScoreRange[1]); 
            </c:if>     
                if(document.getElementById("collapseSearch").style.display === '') {
                    document.getElementById("searchBoxDiv").style.display = 'none';
                }
            }

            function updateCurrentTab(tab) {
                currentTab = tab;
                switch (currentTab) {
                    case 'all':
                        document.getElementById("closedVuln").style.display = 'block';
                        $('#allVulnTable').DataTable().clear();
                        $('#allVulnTable').on('load', loadAllVulnTable());
                        break;

                    case 'new':
                        document.getElementById("closedVuln").style.display = 'block';
                        $('#lastVulnTable').DataTable().clear();
                        $('#lastVulnTable').on('load', loadLastVulnTable());
                        break;

                    case 'closed':
                        document.getElementById("closedVuln").style.display = 'block';
                        $('#closedVulnTable').DataTable().clear();
                        $('#closedVulnTable').on('load', loadClosedVulnTable());
                        break;
                        
                    case 'archived':
                        document.getElementById("closedVuln").style.display = 'none';
                        $('#archivedVulnTable').DataTable().clear();
                        $('#archivedVulnTable').on('load', loadArchivedVulnTable());
                        break;
                        
                    case 'grouped':
                        document.getElementById("closedVuln").style.display = 'none';
                        $('#groupedVulnTable').DataTable().clear();
                        $('#groupedVulnTable').on('load', loadGroupedVulnTable());
                        setTimeout(function () {
                            $('#groupedVulnTable').DataTable().columns.adjust().draw();
                            vulnGroupCountGraph();
                            vulnGroupStatusGraph();
                            vulnGroupAssetGraph();
                        }, 200);
                        
                        break;
                }
            }
            
            var colorSet = new am4core.ColorSet();
            colorSet.list = ["#C80000", "#199600", "#FFAA00"].map(function (color) {
                return new am4core.color(color);
            });
            
            var vulnGroupCountChart;
            function vulnGroupCountGraph (){
            var temp;
            $("#vulnGroupCountGraph").html();
            if (vulnGroupCountChart !== undefined)
                vulnGroupCountChart.dispose();
            vulnGroupCountChart = am4core.create("vulnGroupCountGraph", am4charts.PieChart3D);
            vulnGroupCountChart.hiddenState.properties.opacity = 0; // this creates initial fade-in
            vulnGroupCountChart.innerRadius = am4core.percent(40);
            vulnGroupCountChart.depth = 20;
            var pieSeries = vulnGroupCountChart.series.push(new am4charts.PieSeries3D());
            pieSeries.dataFields.value = "value";
            pieSeries.dataFields.category = "name";
            pieSeries.dataFields.depthValue = "value";
            pieSeries.innerRadius = am4core.percent(40);
            pieSeries.ticks.template.disabled = true;
            pieSeries.labels.template.disabled = true;
            pieSeries.slices.template.cornerRadius = 5;
            pieSeries.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            pieSeries.slices.template.interactionsEnabled = true;
            vulnGroupCountChart.legend = new am4charts.Legend();
            var legendContainer = am4core.create("vulnGroupCountGraphLegendDiv", am4core.Container);
            legendContainer.width = am4core.percent(100);
            legendContainer.height = am4core.percent(100);
            vulnGroupCountChart.legend.parent = legendContainer;
            vulnGroupCountChart.legend.scale = 0.6;
            vulnGroupCountChart.legend.fontSize = 18;
            vulnGroupCountChart.scale = 1.1;
            var combined = [];
            $.post("vulnGroupCountGraph.json", {${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    for(var i=0;i<temp.length;i++){
                        combined[i] = {"name": <c:out value = "temp[i].name"/>, "value": <c:out value = "temp[i].count"/>};
                    }
                    $('#vulnGroupCountGraph').css("line-height", "");
                    vulnGroupCountChart.data = combined;
                });
            }
            
            var vulnGroupStatusChart;
            function vulnGroupStatusGraph (){
            var temp;
            $("#vulnGroupStatusGraph").html();
            if (vulnGroupStatusChart !== undefined)
                vulnGroupStatusChart.dispose();
            vulnGroupStatusChart = am4core.create("vulnGroupStatusGraph", am4charts.PieChart3D);
            vulnGroupStatusChart.hiddenState.properties.opacity = 0; // this creates initial fade-in
            vulnGroupStatusChart.innerRadius = am4core.percent(40);
            vulnGroupStatusChart.depth = 20;
            var pieSeries = vulnGroupStatusChart.series.push(new am4charts.PieSeries3D());
            pieSeries.colors = colorSet;
            pieSeries.dataFields.value = "value";
            pieSeries.dataFields.category = "name";
            pieSeries.dataFields.depthValue = "value";
            pieSeries.innerRadius = am4core.percent(40);
            pieSeries.ticks.template.disabled = true;
            pieSeries.labels.template.disabled = true;
            pieSeries.slices.template.cornerRadius = 5;
            pieSeries.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            pieSeries.slices.template.interactionsEnabled = true;
            vulnGroupStatusChart.legend = new am4charts.Legend();
            var legendContainer = am4core.create("vulnGroupStatusGraphLegendDiv", am4core.Container);
            legendContainer.width = am4core.percent(100);
            legendContainer.height = am4core.percent(100);
            vulnGroupStatusChart.legend.parent = legendContainer;
            vulnGroupStatusChart.legend.scale = 0.6;
            vulnGroupStatusChart.legend.fontSize = 18;
            vulnGroupStatusChart.scale = 1.1;
            var combined = [];
            $.post("vulnGroupStatusGraph.json", {${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    combined[0] = {"name": '<spring:message code="listVulnerabilities.vulnGroupFullOpen"/>', "value": <c:out value = "temp[0]"/>};
                    combined[1] = {"name": '<spring:message code="listVulnerabilities.vulnGroupFullClosed"/>', "value": <c:out value = "temp[1]"/>};
                    combined[2] = {"name": '<spring:message code="listVulnerabilities.vulnGroupPartialClosed"/>', "value": <c:out value = "temp[2]"/>};
                    $('#vulnGroupStatusGraph').css("line-height", "");
                    vulnGroupStatusChart.data = combined;
                });
            }
            
            var vulnGroupAssetChart;
            function vulnGroupAssetGraph (){
            var temp;
            $("#vulnGroupAssetGraph").html();
            if (vulnGroupAssetChart !== undefined)
                vulnGroupAssetChart.dispose();
            vulnGroupAssetChart = am4core.create("vulnGroupAssetGraph", am4charts.PieChart3D);
            vulnGroupAssetChart.hiddenState.properties.opacity = 0; // this creates initial fade-in
            vulnGroupAssetChart.innerRadius = am4core.percent(40);
            vulnGroupAssetChart.depth = 20;
            var pieSeries = vulnGroupAssetChart.series.push(new am4charts.PieSeries3D());
            pieSeries.dataFields.value = "value";
            pieSeries.dataFields.category = "name";
            pieSeries.dataFields.depthValue = "value";
            pieSeries.innerRadius = am4core.percent(40);
            pieSeries.ticks.template.disabled = true;
            pieSeries.labels.template.disabled = true;
            pieSeries.slices.template.cornerRadius = 5;
            pieSeries.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            pieSeries.slices.template.interactionsEnabled = true;
            vulnGroupAssetChart.legend = new am4charts.Legend();
            var legendContainer = am4core.create("vulnGroupAssetGraphLegendDiv", am4core.Container);
            legendContainer.width = am4core.percent(100);
            legendContainer.height = am4core.percent(100);
            vulnGroupAssetChart.legend.parent = legendContainer;
            vulnGroupAssetChart.legend.scale = 0.6;
            vulnGroupAssetChart.legend.fontSize = 18;
            vulnGroupAssetChart.scale = 1.1;
            var combined = [];
            $.post("vulnGroupAssetGraph.json", {${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    for(var i=0;i<temp.length;i++){
                        combined[i] = {"name": <c:out value = "temp[i].name"/>, "value": <c:out value = "temp[i].count"/>};
                    }
                    $('#vulnGroupAssetGraph').css("line-height", "");
                    vulnGroupAssetChart.data = combined;
                });
            }
            
            $('#searchBox').keydown(function (e) {
                if (e.keyCode in map) {
                    map[e.keyCode] = true;
                    if (map[13] && $('#searchBox').val().length >= 3) {
                        clearInDiv('collapseSearch');
                        refreshTable();
                        
                    }
                }
            }).keyup(function (e) {
                if (e.keyCode in map) {
                    map[e.keyCode] = false;
                }
                unBlockUILoading();
            });

            var oTable;
            var oTable2;
            var oTable3;
            var oTable4;
            var oTable5;

            function loadAllVulnTable() {
                blockUILoading();
                $('#allVulnTable').parents('div.dataTables_wrapper').first().hide();
                oTable = $('#allVulnTable').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'B><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "scrollX": true,
                    "orderClasses": false,
                    "serverSide": true,
                    "bFilter": false,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', targets: 0 },
                    <c:if test="${!allVulnTable.riskScore}">
                        { className: 'noVis', targets: 1 },                                                   
                    </c:if>                         
                    <c:if test="${!sessionScope.performanceScoreActive}">
                    <c:if test="${!allVulnTable.performanceScore}">
                        { className: 'noVis', targets: 2 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.vprScore}">
                        { className: 'noVis', targets: 3 },                                                   
                    </c:if> 
                    </c:if> 
                    <c:if test="${!allVulnTable.vulnerabilityName}">
                        { className: 'noVis', targets: 4 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.scanName}">
                        { className: 'noVis', targets: 5},                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.ip}">
                        { className: 'noVis', targets: 6 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.status}">
                        { className: 'noVis', targets: 7 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.port}">
                        { className: 'noVis', targets: 8 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.virtualHost}">
                        { className: 'noVis', targets: 9 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.label}">
                        { className: 'noVis', targets: 10 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.riskLevel}">
                        { className: 'noVis', targets: 11 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.createDate}">
                        { className: 'noVis', targets: 12 },                                                   
                    </c:if> 
                    <c:if test="${!allVulnTable.updateDate}">
                        { className: 'noVis', targets: 13 },                                                   
                    </c:if>                         
                        { className: 'noVis', targets: 14 },
                        { className: 'noVis', targets: 15 },
                        { className: 'noVis', targets: 16 },
                        { className: 'noVis', targets: 17 },
                        { className: 'noVis', targets: 18 },                        
                        { className: 'noVis', targets: 19 } 
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "columns": [
                        {
                            data: "scanVulnerabilityId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkVulnerability" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {data: "riskScore",
                            render: function (data, type, row) {
                                return getRiskScore(data);
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!allVulnTable.riskScore}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {data: "performanceScore",
                            render: function (data, type, row) {
                                var score;
                                if(data === -1) {
                                    score = 0;
                                } else {
                                    score = data;
                                }
                                return '<div style="margin:auto;width:70px;text-align:center;padding-top:3px;height:25px;background-color:#AADBF9;border-radius:5px" ><b>' + score + '</b></div>';
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!allVulnTable.performanceScore}">
                            ,"visible": false                                                    
                        </c:if>                                                     
                        </c:if>   
                        },
                        {"data": function (data, type) {
                                return getVprScore(data);
                            },
                            "searchable": false,
                            "orderData": [17]
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!allVulnTable.vprScore}">
                            ,"visible": false                                                    
                        </c:if>                                                    
                        </c:if> 
                        },                                          
                        {"data": 'vulnerability.name',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var loginDate = "${sessionScope.lastLoginDate}";
                                var createDateVul = oData.createDate;
                                var loginDateISO = loginDate.replace(/\./g, '-');
                                var createDateVulISO = createDateVul.replace(/\./g, '-');
                                var splitted = createDateVulISO.split(" ")[0].split("-");
                                var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                                splitted = loginDateISO.split(" ")[0].split("-");
                                var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                                if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'><span class='badge badge-danger'><spring:message code='generic.new'/></span>&nbsp" + oData.vulnerability.name + "</a>");
                                    $('td', iRow).css('background-color', 'grey');
                                } else
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'>" + oData.vulnerability.name + "</a>");
                            }
                        <c:if test="${!allVulnTable.vulnerabilityName}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data) {
                                var short;
                                if (data.scanName.length <= 15) {
                                    short = decodeHtml(data.scanName);
                                } else {
                                    short = decodeHtml(data.scanName).substring(0, 14) + '...';
                                }
                                return getScannerLogoWithName(data.source,"${pageContext.request.contextPath}") + " " +'<span data-toggle="tooltip" data-placement="right" title="' + decodeHtml(data.scanName) + '" >&nbsp;' + encodeText(short) + '</span>';
                            },
                            "orderable": false},
                        <c:if test="${!allVulnTable.scanName}">
                            ,"visible": false                                                    
                        </c:if>                          
                        {"data": function (data) {
                                if(data.vulnerability.asset.assetType === 'VIRTUAL_HOST' 
                                        && data.vulnerability.asset.otherIps !== null && data.vulnerability.asset.otherIps.length > 0) {
                                    return data.vulnerability.asset.otherIps[0];
                                } else {
                                    if (data.vulnerability.asset.hostname === null || data.vulnerability.asset.hostname === '') {
                                        return data.vulnerability.asset.ip;
                                    } else {
                                        return '<div >' + data.vulnerability.asset.ip + ' <b>(' + data.vulnerability.asset.hostname + ')</b>' + ' </div>';
                                    }
                                }
                            },
                            "orderData": [15]
                        <c:if test="${!allVulnTable.ip}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {
                            "data": function (data, type, dataToSet) {
                                var statusText = '';
                                
                                if(data.ticket.ticketStatus.name === 'OPEN'){
                                    statusText ='<td><div class="list_vulnerability_open" ><p size=5 color="black"><b>⚠ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'IN_PROGRESS'){
                                    statusText = '<td><div class="list_vulnerability_in_progress"><p size=5 color="black"><b>⌛ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'ON_HOLD'){
                                    statusText = '<td><div class="list_vulnerability_on_hold"><p size=4 color="black"><b>⛔ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                 else if(data.ticket.ticketStatus.name === 'RECHECK'){
                                    statusText = '<td><div class="list_vulnerability_recheck"><p size=5 color="black"><b>🔃 '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'RISK_ACCEPTED'){
                                    statusText = '<td><div <div class="list_vulnerability_risk_accepted"><p size=5 color="black"><b>🔀 '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                 else if(data.ticket.ticketStatus.name === 'CLOSED'){
                                    statusText = '<td><div class="list_vulnerability_closed"><p size=5 color="black"><b>✔ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'FALSE_POSITIVE'){
                                    statusText = '<td><div class="list_vulnerability_false_positive"><p size=5 color="black"><b>➕ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                //statusText += '<b>' + data.ticket.ticketStatus.languageText + '</b><br/>';
                                if (data.ticket === null || data.ticket.assignee === null) {
                                    statusText += '<td><div style="margin-left:50%"><font size="2" color="black"><i class="fas fa-minus"></i></font></div></td>';
                                } 
                                else{
                                     statusText += '<td><div style="text-align:center"><font size="2" color="black">' + data.ticket.assigneeDatatableText+'</font></div></td>';
                                 }
                               return statusText;
                            },
                            "orderData": [19]
                        <c:if test="${!allVulnTable.status}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": 'vulnerability.port',
                            "type": "num",
                            "render": function (data) {
                                if (data.portNumber === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.portNumber + '</span><span style="float: right;">  <b> (' + data.protocol + ')</b></span>';
                            },
                            "searchable": false,
                            "orderData": [18]
                        <c:if test="${!allVulnTable.port}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": 'vulnerability.host',
                            "render": function (data) {
                                if (data.name === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.name;
                            },
                            "searchable": false, 
                            "orderable": false
                        <c:if test="${!allVulnTable.virtualHost}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.vulnerability.labels !== null || data.vulnerability.labels.length !== 0) {
                                    var labels = "";
                                    for (var i = 0; i < data.vulnerability.labels.length; i++) {
                                        for (var j = 0; j < labelsList.length; j++) {
                                            var value = "'>' + decodeHtml(data.vulnerability.labels[i].name) + '<'";
                                            if (decodeHtml(data.vulnerability.labels[i].name) === labelsList[j] && value.indexOf() === -1) {
                                                labels += labelsAndColors[j];
                                                break;
                                            }
                                        }
                                    }
                                    if (labels === "" || labels.length === 0) {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    } else {
                                        return '<div >' + labels + ' </div>';
                                    }
                                } else {
                                    return '<div ><i class="fas fa-minus"></i> </div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!allVulnTable.label}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data, type) {
                                let levelStr = '<div >' + data.vulnerability.riskLevel + ' (' + data.vulnerability.riskDescription + ')' + ' </div>';
                                switch (data.vulnerability.riskLevel) {
                                    case 0 :
                                        return '<div class="riskLevel0 riskLevelCommon">' + levelStr + '</div>';
                                    case 1 :
                                        return '<div class="riskLevel1 riskLevelCommon">' + levelStr + '</div>';
                                    case 2 :
                                        return '<div class="riskLevel2 riskLevelCommon">' + levelStr + '</div>';
                                    case 3 :
                                        return '<div class="riskLevel3 riskLevelCommon">' + levelStr + '</div>';
                                    case 4 :
                                        return '<div class="riskLevel4 riskLevelCommon">' + levelStr + '</div>';
                                    case 5 :
                                        return '<div class="riskLevel5 riskLevelCommon">' + levelStr + '</div>';
                                }
                                return levelStr;
                            },
                            "searchable": false,
                            "orderData": [16]
                        <c:if test="${!allVulnTable.riskLevel}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": 'createDate'
                        <c:if test="${!allVulnTable.createDate}">
                            ,"visible": false                                                    
                        </c:if>  
                        },
                        {"data": function (data, type, dataToSet) {

                                if (data.ticket.updateDate === null) {
                                    return '<div ><i class="fas fa-minus"></i> / <i class="fas fa-minus"></i> </div>';
                                } else {
                                    if (data.ticket.ticketStatus.name === "CLOSED") {
                                        return '<div >' + data.ticket.closingDate + ' ' + data.ticket.closeUserDatatableText + '</div>';
                                    } else {
                                        return '<div >' + data.ticket.updateDate + ' / <i class="fas fa-minus"></i></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!allVulnTable.updateDate}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data) {
                                var html = '<div style="font-size: 11px;" class="dropdown"><button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                                html += '<li><a  href="viewVulnerability.htm?scanVulnerabilityId=' + data.scanVulnerabilityId + '&assetId=<c:out value="${assetId}"/>" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail"/></a></li>  ';
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')" >
                                html += '<li><a  href="addVulnerability.htm?action=update&scanVulnerabilityId=' + data.scanVulnerabilityId + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.edit"/></a></li>  ';
                                //html += '<hr class="bizzy-hr-line"/></li>';
                                //    html += '<a  onclick="deleteRow(\'' + data.scanVulnerabilityId + '\', this)" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a></li>  ';
                                if (data.hasProofFile) {
                                    html += '<li><a href="${pageContext.request.contextPath}/customer/downloadProofFile?scanVulnerabilityId=' + data.scanVulnerabilityId + '&vulnerabilityName=' + data.vulnerability.name + '&${_csrf.parameterName}=${_csrf.token}" method="post"><spring:message code="listVulnerabilities.downloadProofs"/></a></li>  ';
                                }
            </sec:authorize>
                                html += '</ul></div>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'vulnerability.asset.ip',
                            "visible": false
                        },
                        {"data": 'vulnerability.riskLevel',
                            "visible": false
                        },
                        {"data": 'vprScore',
                            "visible": false
                        },                            
                        {"data": 'vulnerability.port.portNumber',
                            "type": "num",
                            "visible": false
                        },
                        {
                            "data": 'ticket.ticketStatus.languageText',
                            "visible": false
                        }
                    ],
                    "order": [16, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadVulnerabilities.json",
                        data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                            obj["newVulnerabilities"] = newVulnerabilities;
                            obj["searchBox"] = $('#searchBox').val();
                          
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            if (jqXHR.status === 403) {
                                window.location = '../error/userForbidden.htm';
                            } else {
                                console.log("Ajax error!" + textStatus + " " + errorThrown);
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                                $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                $("#alertModal").modal("show");
                            }
                        },
                        "complete": function (data) {
                            if (assetPageOpened !== 1) {
                                localStorage.setItem("listVulnerabilities", JSON.stringify(getLocalStorageObjectWithArrayByForm("searchForm")));
                            }
                              unBlockUILoading();
                                $('#allVulnTable').parents('div.dataTables_wrapper').first().show();
                        }
                    },
                    "createdRow": function (row, data, index) {
                        var loginDate = "${sessionScope.lastLoginDate}";
                        var createDateVul = data.createDate;
                        var loginDateISO = loginDate.replace(/\./g, '-');
                        var createDateVulISO = createDateVul.replace(/\./g, '-');
                        var splitted = createDateVulISO.split(" ")[0].split("-");
                        var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                        splitted = loginDateISO.split(" ")[0].split("-");
                        var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                        if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                            $('td', row).css('background-color', '#C9CACE');
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();

                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    
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
                    }
                });
            }
            function loadLastVulnTable() {
                blockUILoading();
                oTable2 = $('#lastVulnTable').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'B><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "scrollX": true,
                    "orderClasses": false,
                    "serverSide": true,
                    "bFilter": false,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', targets: 0 },
                    <c:if test="${!lastVulnTable.riskScore}">
                        { className: 'noVis', targets: 1 },                                                   
                    </c:if>                        
                    <c:if test="${!sessionScope.performanceScoreActive}">
                    <c:if test="${!lastVulnTable.performanceScore}">
                        { className: 'noVis', targets: 2 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.vprScore}">
                        { className: 'noVis', targets: 3 },                                                   
                    </c:if> 
                    </c:if>
                    <c:if test="${!lastVulnTable.vulnerabilityName}">
                        { className: 'noVis', targets: 4 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.scanName}">
                        { className: 'noVis', targets: 5 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.ip}">
                        { className: 'noVis', targets: 6 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.status}">
                        { className: 'noVis', targets: 7 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.port}">
                        { className: 'noVis', targets: 8 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.virtualHost}">
                        { className: 'noVis', targets: 9 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.label}">
                        { className: 'noVis', targets: 10 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.riskLevel}">
                        { className: 'noVis', targets: 11 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.createDate}">
                        { className: 'noVis', targets: 12 },                                                   
                    </c:if> 
                    <c:if test="${!lastVulnTable.updateDate}">
                        { className: 'noVis', targets: 13 },                                                   
                    </c:if>                         
                        { className: 'noVis', targets: 14 },
                        { className: 'noVis', targets: 15 },
                        { className: 'noVis', targets: 16 },
                        { className: 'noVis', targets: 17 },
                        { className: 'noVis', targets: 18 },                        
                        { className: 'noVis', targets: 19 } 
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "columns": [
                        {
                            data: "scanVulnerabilityId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkVulnerabilityL" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {data: "riskScore",
                            render: function (data, type, row) {
                                return getRiskScore(data);
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!lastVulnTable.riskScore}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {data: "performanceScore",
                            render: function (data, type, row) {
                                var score;
                                if(data === -1) {
                                    score = 0;
                                } else {
                                    score = data;
                                }                                
                                return '<div style="margin:auto;width:70px;text-align:center;padding-top:3px;height:25px;background-color:#AADBF9;border-radius:5px" ><b>' + score + '</b></div>';
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!lastVulnTable.performanceScore}">
                            ,"visible": false                                                    
                        </c:if>                                                     
                        </c:if>   
                        },
                        {"data": function (data, type) {
                                return getVprScore(data);
                            },
                            "searchable": false,
                            "orderData": [17]
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!lastVulnTable.vprScore}">
                            ,"visible": false                                                    
                        </c:if>                                                     
                        </c:if> 
                        },                          
                        {"data": 'vulnerability.name',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var loginDate = "${sessionScope.lastLoginDate}";
                                var createDateVul = oData.createDate;
                                var loginDateISO = loginDate.replace(/\./g, '-');
                                var createDateVulISO = createDateVul.replace(/\./g, '-');
                                var splitted = createDateVulISO.split(" ")[0].split("-");
                                var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                                splitted = loginDateISO.split(" ")[0].split("-");
                                var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                                if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'><span class='badge badge-danger'><spring:message code='generic.new'/></span>&nbsp" + oData.vulnerability.name + "</a>");
                                    $('td', iRow).css('background-color', 'grey');
                                } else
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'>" + oData.vulnerability.name + "</a>");
                            }
                        <c:if test="${!lastVulnTable.vulnerabilityName}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data) {
                                var short;
                                if (data.scanName.length <= 15) {
                                    short = decodeHtml(data.scanName);
                                } else {
                                    short = decodeHtml(data.scanName).substring(0, 14) + '...';
                                }
                                return getScannerLogoWithName(data.source,"${pageContext.request.contextPath}") + " " +'<span data-toggle="tooltip" data-placement="right" title="' + decodeHtml(data.scanName) + '" >&nbsp;' + encodeText(short) + '</span>';
                            },
                            "orderable": false
                        <c:if test="${!lastVulnTable.scanName}">
                            ,"visible": false                                                    
                        </c:if>                     
                        },
                        {"data": function (data) {
                                if(data.vulnerability.asset.assetType === 'VIRTUAL_HOST' 
                                        && data.vulnerability.asset.otherIps !== null && data.vulnerability.asset.otherIps.length > 0) {
                                    return data.vulnerability.asset.otherIps[0];
                                } else {
                                    if (data.vulnerability.asset.hostname === null || data.vulnerability.asset.hostname === '') {
                                        return data.vulnerability.asset.ip;
                                    } else {
                                        return '<div >' + data.vulnerability.asset.ip + ' <b>(' + data.vulnerability.asset.hostname + ')</b>' + ' </div>';
                                    }
                                }
                            },
                            "orderData": [15]
                        <c:if test="${!lastVulnTable.ip}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {
                            "data": function (data, type, dataToSet) {
                                var statusText = '';
                                
                                if(data.ticket.ticketStatus.name === 'OPEN'){
                                    statusText ='<td><div class="list_vulnerability_open" ><p size=5 color="black"><b>⚠ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'IN_PROGRESS'){
                                    statusText = '<td><div class="list_vulnerability_in_progress"><p size=5 color="black"><b>⌛ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'ON_HOLD'){
                                    statusText = '<td><div class="list_vulnerability_on_hold"><p size=4 color="black"><b>⛔ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                 else if(data.ticket.ticketStatus.name === 'RECHECK'){
                                    statusText = '<td><div class="list_vulnerability_recheck"><p size=5 color="black"><b>🔃 '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'RISK_ACCEPTED'){
                                    statusText = '<td><div <div class="list_vulnerability_risk_accepted"><p size=5 color="black"><b>🔀 '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                 else if(data.ticket.ticketStatus.name === 'CLOSED'){
                                    statusText = '<td><div class="list_vulnerability_closed"><p size=5 color="black"><b>✔ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'FALSE_POSITIVE'){
                                    statusText = '<td><div class="list_vulnerability_false_positive"><p size=5 color="black"><b>➕ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                //statusText += '<b>' + data.ticket.ticketStatus.languageText + '</b><br/>';
                                if (data.ticket === null || data.ticket.assignee === null) {
                                    statusText += '<td><div style="margin-left:50%"><font size="2" color="black"><i class="fas fa-minus"></i></font></div></td>';
                                } 
                                else{
                                     statusText += '<td><div style="text-align:center"><font size="2" color="black">' + data.ticket.assigneeDatatableText+'</font></div></td>';
                                 }
                               return statusText;
                            },
                            "orderData": [19]
                        <c:if test="${!lastVulnTable.status}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": 'vulnerability.port',
                            "type": "num",
                            "render": function (data) {
                                if (data.portNumber === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.portNumber + '</span><span style="float: right;">  <b> (' + data.protocol + ')</b></span>';
                            },
                            "searchable": false,
                            "orderData": [18],
                            "width": "2%"
                        <c:if test="${!lastVulnTable.port}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": 'vulnerability.host',
                            "render": function (data) {
                                if (data.name === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.name;
                            },
                            "searchable": false, 
                            "orderable": false
                        <c:if test="${!lastVulnTable.virtualHost}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.vulnerability.labels !== null || data.vulnerability.labels.length !== 0) {
                                    var labels = "";
                                    for (var i = 0; i < data.vulnerability.labels.length; i++) {
                                        for (var j = 0; j < labelsList.length; j++) {
                                            var value = "'>' + decodeHtml(data.vulnerability.labels[i].name) + '<'";
                                            if (decodeHtml(data.vulnerability.labels[i].name) === labelsList[j] && value.indexOf() === -1) {
                                                labels += labelsAndColors[j];
                                                break;
                                            }
                                        }
                                    }
                                    if (labels === "" || labels.length === 0) {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    } else {
                                        return '<div >' + labels + ' </div>';
                                    }
                                } else {
                                    return '<div ><i class="fas fa-minus"></i> </div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!lastVulnTable.label}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data, type) {
                                let levelStr = '<div >' + data.vulnerability.riskLevel + ' (' + data.vulnerability.riskDescription + ')' + ' </div>';
                                switch (data.vulnerability.riskLevel) {
                                    case 0 :
                                        return '<div class="riskLevel0 riskLevelCommon">' + levelStr + '</div>';
                                    case 1 :
                                        return '<div class="riskLevel1 riskLevelCommon">' + levelStr + '</div>';
                                    case 2 :
                                        return '<div class="riskLevel2 riskLevelCommon">' + levelStr + '</div>';
                                    case 3 :
                                        return '<div class="riskLevel3 riskLevelCommon">' + levelStr + '</div>';
                                    case 4 :
                                        return '<div class="riskLevel4 riskLevelCommon">' + levelStr + '</div>';
                                    case 5 :
                                        return '<div class="riskLevel5 riskLevelCommon">' + levelStr + '</div>';
                                }
                                return levelStr;
                            },
                            "searchable": false,
                            "orderData": [16]
                        <c:if test="${!lastVulnTable.riskLevel}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": 'createDate'
                        <c:if test="${!lastVulnTable.createDate}">
                            ,"visible": false                                                    
                        </c:if>                     
                        },
                        {"data": function (data, type, dataToSet) {

                                if (data.ticket.updateDate === null) {
                                    return '<div ><i class="fas fa-minus"></i> / <i class="fas fa-minus"></i> </div>';
                                } else {
                                    if (data.ticket.ticketStatus.name === "CLOSED") {
                                        return '<div >' + data.ticket.closingDate + ' ' + data.ticket.closeUserDatatableText + '</div>';
                                    } else {
                                        return '<div >' + data.ticket.updateDate + ' / <i class="fas fa-minus"></i></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!lastVulnTable.updateDate}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data) {
                                var html = '<div style="font-size: 11px;" class="dropdown"><button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                                html += '<li><a  href="viewVulnerability.htm?scanVulnerabilityId=' + data.scanVulnerabilityId + '&assetId=<c:out value="${assetId}"/>" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail"/></a></li>  ';
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER')" >
                                html += '<li><a  href="addVulnerability.htm?action=update&scanVulnerabilityId=' + data.scanVulnerabilityId + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.edit"/></a></li>  ';
                                //    html += '<a  onclick="deleteRow(\'' + data.scanVulnerabilityId + '\', this)" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a>  ';
                                if (data.hasProofFile) {
                                    html += '<li><a href="${pageContext.request.contextPath}/customer/downloadProofFile?scanVulnerabilityId=' + data.scanVulnerabilityId + '&vulnerabilityName=' + data.vulnerability.name + '&${_csrf.parameterName}=${_csrf.token}"><spring:message code="listVulnerabilities.downloadProofs"/></a></li>  ';
                                }
            </sec:authorize>
                                html += '</ul></div>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'vulnerability.asset.ip',
                            "visible": false
                        },
                        {"data": 'vulnerability.riskLevel',
                            "visible": false
                        },
                        {"data": 'vprScore',
                            "visible": false
                        },                               
                        {"data": 'vulnerability.port.portNumber',
                            "type": "num",
                            "visible": false
                        },
                        {
                            "data": 'ticket.ticketStatus.languageText',
                            "orderable": false,
                            "visible": false
                        }
                    ],
                    "order": [16, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadLastVulnerabilities.json",
                        data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                            obj["newVulnerabilities"] = newVulnerabilities;
                            obj["searchBox"] = $('#searchBox').val();
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            if (jqXHR.status === 403) {
                                window.location = '../error/userForbidden.htm';
                            } else {
                                console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                                $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                $("#alertModal").modal("show");
                            }
                        },
                        "complete": function (data) {
                            if (assetPageOpened !== 1) {
                                localStorage.setItem("listVulnerabilities", JSON.stringify(getLocalStorageObjectWithArrayByForm("searchForm")));
                            }
                            unBlockUILoading();
                        }
                    },
                    "createdRow": function (row, data, index) {
                        var loginDate = "${sessionScope.lastLoginDate}";
                        var createDateVul = data.createDate;
                        var loginDateISO = loginDate.replace(/\./g, '-');
                        var createDateVulISO = createDateVul.replace(/\./g, '-');
                        var splitted = createDateVulISO.split(" ")[0].split("-");
                        var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                        splitted = loginDateISO.split(" ")[0].split("-");
                        var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                        if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                            $('td', row).css('background-color', '#C9CACE');
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        oTable2.fnAdjustColumnSizing();
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
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
                    }

                });
            }
            function loadArchivedVulnTable() {
            blockUILoading();
                $('#archivedVulnTable').parents('div.dataTables_wrapper').first().hide();
                oTable5 = $('#archivedVulnTable').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'B><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "scrollX": true,
                    "orderClasses": false,
                    "serverSide": true,
                    "bFilter": false,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', targets: 0 },
                    <c:if test="${!archivedVulnTable.riskScore}">
                        { className: 'noVis', targets: 1 },                                                   
                    </c:if>                         
                    <c:if test="${!sessionScope.performanceScoreActive}">
                    <c:if test="${!archivedVulnTable.performanceScore}">
                        { className: 'noVis', targets: 2 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.vprScore}">
                        { className: 'noVis', targets: 3 },                                                   
                    </c:if> 
                    </c:if> 
                    <c:if test="${!archivedVulnTable.vulnerabilityName}">
                        { className: 'noVis', targets: 4 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.scanName}">
                        { className: 'noVis', targets: 5},                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.ip}">
                        { className: 'noVis', targets: 6 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.status}">
                        { className: 'noVis', targets: 7 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.port}">
                        { className: 'noVis', targets: 8 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.virtualHost}">
                        { className: 'noVis', targets: 9 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.label}">
                        { className: 'noVis', targets: 10 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.riskLevel}">
                        { className: 'noVis', targets: 11 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.createDate}">
                        { className: 'noVis', targets: 12 },                                                   
                    </c:if> 
                    <c:if test="${!archivedVulnTable.updateDate}">
                        { className: 'noVis', targets: 13 },                                                   
                    </c:if>                         
                        { className: 'noVis', targets: 14 },
                        { className: 'noVis', targets: 15 },
                        { className: 'noVis', targets: 16 },
                        { className: 'noVis', targets: 17 },
                        { className: 'noVis', targets: 18 },                        
                        { className: 'noVis', targets: 19 } 
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "columns": [
                        {
                            data: "scanVulnerabilityId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkVulnerability" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {data: "riskScore",
                            render: function (data, type, row) {
                                return getRiskScore(data);
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!archivedVulnTable.riskScore}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {data: "performanceScore",
                            render: function (data, type, row) {
                                var score;
                                if(data === -1) {
                                    score = 0;
                                } else {
                                    score = data;
                                }
                                return '<div style="margin:auto;width:70px;text-align:center;padding-top:3px;height:25px;background-color:#AADBF9;border-radius:5px" ><b>' + score + '</b></div>';
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!archivedVulnTable.performanceScore}">
                            ,"visible": false                                                    
                        </c:if>                                                     
                        </c:if>   
                        },
                        {"data": function (data, type) {
                                return getVprScore(data);
                            },
                            "searchable": false,
                            "orderData": [17]
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!archivedVulnTable.vprScore}">
                            ,"visible": false                                                    
                        </c:if>                                                    
                        </c:if> 
                        },                                          
                        {"data": 'vulnerability.name',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var loginDate = "${sessionScope.lastLoginDate}";
                                var createDateVul = oData.createDate;
                                var loginDateISO = loginDate.replace(/\./g, '-');
                                var createDateVulISO = createDateVul.replace(/\./g, '-');
                                var splitted = createDateVulISO.split(" ")[0].split("-");
                                var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                                splitted = loginDateISO.split(" ")[0].split("-");
                                var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                                if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'><span class='badge badge-danger'><spring:message code='generic.new'/></span>&nbsp" + oData.vulnerability.name + "</a>");
                                    $('td', iRow).css('background-color', 'grey');
                                } else
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'>" + oData.vulnerability.name + "</a>");
                            }
                        <c:if test="${!archivedVulnTable.vulnerabilityName}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data) {
                                var short;
                                if (data.scanName.length <= 15) {
                                    short = decodeHtml(data.scanName);
                                } else {
                                    short = decodeHtml(data.scanName).substring(0, 14) + '...';
                                }
                                return getScannerLogoWithName(data.source,"${pageContext.request.contextPath}") + " " +'<span data-toggle="tooltip" data-placement="right" title="' + decodeHtml(data.scanName) + '" >&nbsp;' + encodeText(short) + '</span>';
                            },
                            "orderable": false},
                        <c:if test="${!archivedVulnTable.scanName}">
                            ,"visible": false                                                    
                        </c:if>                          
                        {"data": function (data) {
                                if(data.vulnerability.asset.assetType === 'VIRTUAL_HOST' 
                                        && data.vulnerability.asset.otherIps !== null && data.vulnerability.asset.otherIps.length > 0) {
                                    return data.vulnerability.asset.otherIps[0];
                                } else {
                                    if (data.vulnerability.asset.hostname === null || data.vulnerability.asset.hostname === '') {
                                        return data.vulnerability.asset.ip;
                                    } else {
                                        return '<div >' + data.vulnerability.asset.ip + ' <b>(' + data.vulnerability.asset.hostname + ')</b>' + ' </div>';
                                    }
                                }
                            },
                            "orderData": [15]
                        <c:if test="${!archivedVulnTable.ip}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {
                            "data": function (data, type, dataToSet) {
                                var statusText = '';
                                
                                if(data.ticket.ticketStatus.name === 'OPEN'){
                                    statusText ='<td><div class="list_vulnerability_open" ><p size=5 color="black"><b>⚠ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'IN_PROGRESS'){
                                    statusText = '<td><div class="list_vulnerability_in_progress"><p size=5 color="black"><b>⌛ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'ON_HOLD'){
                                    statusText = '<td><div class="list_vulnerability_on_hold"><p size=4 color="black"><b>⛔ '+ data.ticket.ticketStatus.languageText +'</b><br/></p></div></td>';
                                }
                                 else if(data.ticket.ticketStatus.name === 'RECHECK'){
                                    statusText = '<td><div class="list_vulnerability_recheck"><p size=5 color="black"><b>🔃 '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'RISK_ACCEPTED'){
                                    statusText = '<td><div <div class="list_vulnerability_risk_accepted"><p size=5 color="black"><b>🔀 '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                 else if(data.ticket.ticketStatus.name === 'CLOSED'){
                                    statusText = '<td><div class="list_vulnerability_closed"><p size=5 color="black"><b>✔ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                else if(data.ticket.ticketStatus.name === 'FALSE_POSITIVE'){
                                    statusText = '<td><div class="list_vulnerability_false_positive"><p size=5 color="black"><b>➕ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                //statusText += '<b>' + data.ticket.ticketStatus.languageText + '</b><br/>';
                                if (data.ticket === null || data.ticket.assignee === null) {
                                    statusText += '<td><div style="margin-left:50%"><font size="2" color="black"><i class="fas fa-minus"></i></font></div></td>';
                                } 
                                else{
                                     statusText += '<td><div style="text-align:center"><font size="2" color="black">' + data.ticket.assigneeDatatableText+'</font></div></td>';
                                 }
                               return statusText;
                            },
                            "orderData": [19]
                        <c:if test="${!archivedVulnTable.status}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": 'vulnerability.port',
                            "type": "num",
                            "render": function (data) {
                                if (data.portNumber === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.portNumber + '</span><span style="float: right;">  <b> (' + data.protocol + ')</b></span>';
                            },
                            "searchable": false,
                            "orderData": [18]
                        <c:if test="${!archivedVulnTable.port}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": 'vulnerability.host',
                            "render": function (data) {
                                if (data.name === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.name;
                            },
                            "searchable": false, 
                            "orderable": false
                        <c:if test="${!archivedVulnTable.virtualHost}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.vulnerability.labels !== null || data.vulnerability.labels.length !== 0) {
                                    var labels = "";
                                    for (var i = 0; i < data.vulnerability.labels.length; i++) {
                                        for (var j = 0; j < labelsList.length; j++) {
                                            var value = "'>' + decodeHtml(data.vulnerability.labels[i].name) + '<'";
                                            if (decodeHtml(data.vulnerability.labels[i].name) === labelsList[j] && value.indexOf() === -1) {
                                                labels += labelsAndColors[j];
                                                break;
                                            }
                                        }
                                    }
                                    if (labels === "" || labels.length === 0) {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    } else {
                                        return '<div >' + labels + ' </div>';
                                    }
                                } else {
                                    return '<div ><i class="fas fa-minus"></i> </div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!archivedVulnTable.label}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data, type) {
                                let levelStr = '<div >' + data.vulnerability.riskLevel + ' (' + data.vulnerability.riskDescription + ')' + ' </div>';
                                switch (data.vulnerability.riskLevel) {
                                    case 0 :
                                        return '<div class="riskLevel0 riskLevelCommon">' + levelStr + '</div>';
                                    case 1 :
                                        return '<div class="riskLevel1 riskLevelCommon">' + levelStr + '</div>';
                                    case 2 :
                                        return '<div class="riskLevel2 riskLevelCommon">' + levelStr + '</div>';
                                    case 3 :
                                        return '<div class="riskLevel3 riskLevelCommon">' + levelStr + '</div>';
                                    case 4 :
                                        return '<div class="riskLevel4 riskLevelCommon">' + levelStr + '</div>';
                                    case 5 :
                                        return '<div class="riskLevel5 riskLevelCommon">' + levelStr + '</div>';
                                }
                                return levelStr;
                            },
                            "searchable": false,
                            "orderData": [16]
                        <c:if test="${!archivedVulnTable.riskLevel}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": 'createDate'
                        <c:if test="${!archivedVulnTable.createDate}">
                            ,"visible": false                                                    
                        </c:if>  
                        },
                        {"data": function (data, type, dataToSet) {

                                if (data.ticket.updateDate === null) {
                                    return '<div ><i class="fas fa-minus"></i> / <i class="fas fa-minus"></i> </div>';
                                } else {
                                    if (data.ticket.ticketStatus.name === "CLOSED") {
                                        return '<div >' + data.ticket.closingDate + ' ' + data.ticket.closeUserDatatableText + '</div>';
                                    } else {
                                        return '<div >' + data.ticket.updateDate + ' / <i class="fas fa-minus"></i></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!archivedVulnTable.updateDate}">
                            ,"visible": false                                                    
                        </c:if>                              
                        },
                        {"data": function (data) {
                                var html = '<div style="font-size: 11px;" class="dropdown"><button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                                html += '<li><a  href="viewVulnerability.htm?scanVulnerabilityId=' + data.scanVulnerabilityId + '&assetId=<c:out value="${assetId}"/>" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail"/></a></li>  ';
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER')" >
                                html += '<li><a  href="addVulnerability.htm?action=update&scanVulnerabilityId=' + data.scanVulnerabilityId + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.edit"/></a></li>  ';
                                //html += '<hr class="bizzy-hr-line"/></li>';
                                //    html += '<a  onclick="deleteRow(\'' + data.scanVulnerabilityId + '\', this)" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a></li>  ';
                                if (data.hasProofFile) {
                                    html += '<li><a href="${pageContext.request.contextPath}/customer/downloadProofFile?scanVulnerabilityId=' + data.scanVulnerabilityId + '&vulnerabilityName=' + data.vulnerability.name + '&${_csrf.parameterName}=${_csrf.token}" method="post"><spring:message code="listVulnerabilities.downloadProofs"/></a></li>  ';
                                }
            </sec:authorize>
                                html += '</ul></div>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'vulnerability.asset.ip',
                            "visible": false
                        },
                        {"data": 'vulnerability.riskLevel',
                            "visible": false
                        },
                        {"data": 'vprScore',
                            "visible": false
                        },                            
                        {"data": 'vulnerability.port.portNumber',
                            "type": "num",
                            "visible": false
                        },
                        {
                            "data": 'ticket.ticketStatus.languageText',
                            "visible": false
                        }
                    ],
                    "order": [16, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadArchivedVulnerabilities.json",
                        data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                            obj["newVulnerabilities"] = newVulnerabilities;
                            obj["searchBox"] = $('#searchBox').val();
                          
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            if (jqXHR.status === 403) {
                                window.location = '../error/userForbidden.htm';
                            } else {
                                console.log("Ajax error!" + textStatus + " " + errorThrown);
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                                $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                $("#alertModal").modal("show");
                            }
                        },
                        "complete": function (data) {
                            if (assetPageOpened !== 1) {
                                localStorage.setItem("listVulnerabilities", JSON.stringify(getLocalStorageObjectWithArrayByForm("searchForm")));
                            }
                              unBlockUILoading();
                                $('#archivedVulnTable').parents('div.dataTables_wrapper').first().show();
                        }
                    },
                    "createdRow": function (row, data, index) {
                        var loginDate = "${sessionScope.lastLoginDate}";
                        var createDateVul = data.createDate;
                        var loginDateISO = loginDate.replace(/\./g, '-');
                        var createDateVulISO = createDateVul.replace(/\./g, '-');
                        var splitted = createDateVulISO.split(" ")[0].split("-");
                        var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                        splitted = loginDateISO.split(" ")[0].split("-");
                        var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                        if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                            $('td', row).css('background-color', '#C9CACE');
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();

                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    
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
                    }
                });
            }
            function loadClosedVulnTable() {
                blockUILoading();
                oTable3 = $('#closedVulnTable').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'B><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "scrollX": true,
                    "orderClasses": false,
                    "serverSide": true,
                    "bFilter": false,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', targets: 0 },
                    <c:if test="${!closedVulnTable.riskScore}">
                        { className: 'noVis', targets: 1 },                                                   
                    </c:if>                        
                    <c:if test="${!sessionScope.performanceScoreActive}">
                    <c:if test="${!closedVulnTable.performanceScore}">
                        { className: 'noVis', targets: 2 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.vprScore}">
                        { className: 'noVis', targets: 3 },                                                   
                    </c:if>
                    </c:if> 
                    <c:if test="${!closedVulnTable.vulnerabilityName}">
                        { className: 'noVis', targets: 4 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.scanName}">
                        { className: 'noVis', targets: 5 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.ip}">
                        { className: 'noVis', targets: 6 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.status}">
                        { className: 'noVis', targets: 7 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.port}">
                        { className: 'noVis', targets: 8 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.virtualHost}">
                        { className: 'noVis', targets: 9 },                                                   
                    </c:if> 
                    <c:if test="${!closedVulnTable.label}">
                        { className: 'noVis', targets: 10 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.riskLevel}">
                        { className: 'noVis', targets: 11 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.createDate}">
                        { className: 'noVis', targets: 12 },                                                   
                    </c:if>
                    <c:if test="${!closedVulnTable.updateDate}">
                        { className: 'noVis', targets: 13 },                                                   
                    </c:if>                         
                        { className: 'noVis', targets: 14 },
                        { className: 'noVis', targets: 15 },
                        { className: 'noVis', targets: 16 },
                        { className: 'noVis', targets: 17 },
                        { className: 'noVis', targets: 18 },                        
                        { className: 'noVis', targets: 19 } 
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "columns": [
                        {
                            data: "scanVulnerabilityId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkVulnerabilityC" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {data: "riskScore",
                            render: function (data, type, row) {
                                return getRiskScore(data);
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!closedVulnTable.riskScore}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {data: "performanceScore",
                            render: function (data, type, row) {
                                var score;
                                if(data === -1) {
                                    score = 0;
                                } else {
                                    score = data;
                                }                                
                                return '<div style="margin:auto;width:70px;text-align:center;padding-top:3px;height:25px;background-color:#AADBF9;border-radius:5px" ><b>' + score + '</b></div>';
                            },
                            "searchable": false,
                            "orderable": true
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!closedVulnTable.performanceScore}">
                            ,"visible": false                                                    
                        </c:if>                                                    
                        </c:if>   
                        },
                        {"data": function (data, type) {
                                return getVprScore(data);
                            },
                            "searchable": false,
                            "orderData": [17]
                        <c:if test="${!sessionScope.performanceScoreActive}">
                        <c:if test="${!closedVulnTable.vprScore}">
                            ,"visible": false                                                    
                        </c:if>                                                    
                        </c:if> 
                        },                                      
                        {"data": 'vulnerability.name',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var loginDate = "${sessionScope.lastLoginDate}";
                                var createDateVul = oData.createDate;
                                var loginDateISO = loginDate.replace(/\./g, '-');
                                var createDateVulISO = createDateVul.replace(/\./g, '-');
                                var splitted = createDateVulISO.split(" ")[0].split("-");
                                var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                                splitted = loginDateISO.split(" ")[0].split("-");
                                var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                                if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'><span class='badge badge-danger'><spring:message code='generic.new'/></span>&nbsp" + oData.vulnerability.name + "</a>");
                                    $('td', iRow).css('background-color', 'grey');
                                } else
                                    $(nTd).html("<a href='viewVulnerability.htm?scanVulnerabilityId=" + oData.scanVulnerabilityId + "'>" + oData.vulnerability.name + "</a>");
                            }
                        <c:if test="${!closedVulnTable.vulnerabilityName}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data) {
                                var short;
                                if (data.scanName.length <= 15) {
                                    short = decodeHtml(data.scanName);
                                } else {
                                    short = decodeHtml(data.scanName).substring(0, 14) + '...';
                                }
                                return getScannerLogoWithName(data.source,"${pageContext.request.contextPath}") + " " +'<span data-toggle="tooltip" data-placement="right" title="' + decodeHtml(data.scanName) + '" >&nbsp;' + encodeText(short) + '</span>';
                            },
                            "orderable": false
                        <c:if test="${!closedVulnTable.scanName}">
                            ,"visible": false                                                    
                        </c:if>                     
                        },
                        {"data": function (data) {
                                if(data.vulnerability.asset.assetType === 'VIRTUAL_HOST' 
                                        && data.vulnerability.asset.otherIps !== null && data.vulnerability.asset.otherIps.length > 0) {
                                    return data.vulnerability.asset.otherIps[0];
                                } else {
                                    if (data.vulnerability.asset.hostname === null || data.vulnerability.asset.hostname === '') {
                                        return data.vulnerability.asset.ip;
                                    } else {
                                        return '<div >' + data.vulnerability.asset.ip + ' <b>(' + data.vulnerability.asset.hostname + ')</b>' + ' </div>';
                                    }
                                }
                            },
                            "orderData": [15]
                        <c:if test="${!closedVulnTable.ip}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {
                            "data": function (data, type, dataToSet) {
                               var statusText = '';
                                if(data.ticket.ticketStatus.name === 'CLOSED'){
                                    statusText = '<td><div class="list_vulnerability_closed"><p size=5 color="black"><b>✔ '+ data.ticket.ticketStatus.languageText +'</b><br/></div></td>';
                                }
                                if (data.ticket === null || data.ticket.assignee === null) {
                                    statusText += '<td><div style="margin-left:50%"><font size="2" color="black"><i class="fas fa-minus"></i></font></div></td>';
                                } 
                                else{
                                     statusText += '<td><div style="text-align:center"><font size="2" color="black">' + data.ticket.assigneeDatatableText+'</font></div></td>';
                                 }
                               return statusText;
                            },
                            "orderData": [19]
                        <c:if test="${!closedVulnTable.status}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": 'vulnerability.port',
                            "type": "num",
                            "render": function (data) {
                                if (data.portNumber === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.portNumber + '</span><span style="float: right;">  <b> (' + data.protocol + ')</b></span>';
                            },
                            "searchable": false,
                            "orderData": [18],
                            "width": "2%"
                        <c:if test="${!closedVulnTable.port}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": 'vulnerability.host',
                            "render": function (data) {
                                if (data.name === null) {
                                    return '<div><i class="fas fa-minus"></i> </div>';
                                }
                                return '<span style="float: left;">' + data.name;
                            },
                            "searchable": false, 
                            "orderable": false
                        <c:if test="${!closedVulnTable.virtualHost}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.vulnerability.labels !== null || data.vulnerability.labels.length !== 0) {
                                    var labels = "";
                                    for (var i = 0; i < data.vulnerability.labels.length; i++) {
                                        for (var j = 0; j < labelsList.length; j++) {
                                            var value = "'>' + decodeHtml(data.vulnerability.labels[i].name) + '<'";
                                            if (decodeHtml(data.vulnerability.labels[i].name) === labelsList[j] && value.indexOf() === -1) {
                                                labels += labelsAndColors[j];
                                                break;
                                            }
                                        }
                                    }
                                    if (labels === "" || labels.length === 0) {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    } else {
                                        return '<div >' + labels + ' </div>';
                                    }
                                } else {
                                    return '<div ><i class="fas fa-minus"></i> </div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!closedVulnTable.label}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data, type) {
                                let levelStr = '<div >' + data.vulnerability.riskLevel + ' (' + data.vulnerability.riskDescription + ')' + ' </div>';
                                switch (data.vulnerability.riskLevel) {
                                    case 0 :
                                        return '<div class="riskLevel0 riskLevelCommon">' + levelStr + '</div>';
                                    case 1 :
                                        return '<div class="riskLevel1 riskLevelCommon">' + levelStr + '</div>';
                                    case 2 :
                                        return '<div class="riskLevel2 riskLevelCommon">' + levelStr + '</div>';
                                    case 3 :
                                        return '<div class="riskLevel3 riskLevelCommon">' + levelStr + '</div>';
                                    case 4 :
                                        return '<div class="riskLevel4 riskLevelCommon">' + levelStr + '</div>';
                                    case 5 :
                                        return '<div class="riskLevel5 riskLevelCommon">' + levelStr + '</div>';
                                }
                                return levelStr;
                            },
                            "searchable": false,
                            "orderData": [16]
                        <c:if test="${!closedVulnTable.riskLevel}">
                            ,"visible": false                                                    
                        </c:if>                            
                        },
                        {"data": 'createDate'
                        <c:if test="${!closedVulnTable.createDate}">
                            ,"visible": false                                                    
                        </c:if>                     
                        },
                        {"data": function (data, type, dataToSet) {

                                if (data.ticket.updateDate === null) {
                                    return '<div ><i class="fas fa-minus"></i> / <i class="fas fa-minus"></i> </div>';
                                } else {
                                    if (data.ticket.ticketStatus.name === "CLOSED") {
                                        return '<div >' + data.ticket.closingDate + ' ' + data.ticket.closeUserDatatableText + '</div>';
                                    } else {
                                        return '<div >' + data.ticket.updateDate + ' / <i class="fas fa-minus"></i></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        <c:if test="${!closedVulnTable.updateDate}">
                            ,"visible": false                                                    
                        </c:if>                             
                        },
                        {"data": function (data) {
                                var html = '<div class="dropdown"><button style="font-size: 11px;" class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                                html += '<li><a  href="viewVulnerability.htm?scanVulnerabilityId=' + data.scanVulnerabilityId + '&assetId=<c:out value="${assetId}"/>" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail"/></a></li>  ';
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER')" >
                                html += '<li><a  href="addVulnerability.htm?action=update&scanVulnerabilityId=' + data.scanVulnerabilityId + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.edit"/></a> </li> ';
                                //        html += '<a  onclick="deleteRow(\'' + data.scanVulnerabilityId + '\', this)" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a>  ';
                                if (data.hasProofFile) {
                                    html += '<li><a href="${pageContext.request.contextPath}/customer/downloadProofFile?scanVulnerabilityId=' + data.scanVulnerabilityId + '&vulnerabilityName=' + data.vulnerability.name + '&${_csrf.parameterName}=${_csrf.token}"><spring:message code="listVulnerabilities.downloadProofs"/></a></li>  ';
                                }
            </sec:authorize>
                                html += '</ul></div>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false},
                        {"data": 'vulnerability.asset.ip',
                            "visible": false
                        },
                        {"data": 'vulnerability.riskLevel',
                            "visible": false
                        },
                        {"data": 'vprScore',
                            "visible": false
                        },                              
                        {"data": 'vulnerability.port.portNumber',
                            "type": "num",
                            "visible": false
                        },
                        {
                            "data": 'ticket.ticketStatus.languageText',
                            "orderable": false,
                            "visible": false
                        }
                    ],
                    "order": [16, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadClosedVulnerabilities.json",
                        data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                            obj["newVulnerabilities"] = newVulnerabilities;
                            obj["searchBox"] = $('#searchBox').val();
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            if (jqXHR.status === 403) {
                                window.location = '../error/userForbidden.htm';
                            } else {
                                console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                                $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                $("#alertModal").modal("show");
                            }
                        },
                        "complete": function (data) {
                            if (assetPageOpened !== 1) {
                                localStorage.setItem("listVulnerabilities", JSON.stringify(getLocalStorageObjectWithArrayByForm("searchForm")));
                            }
                            unBlockUILoading();
                        }
                    },
                    "createdRow": function (row, data, index) {
                        var loginDate = "${sessionScope.lastLoginDate}";
                        var createDateVul = data.createDate;
                        var loginDateISO = loginDate.replace(/\./g, '-');
                        var createDateVulISO = createDateVul.replace(/\./g, '-');
                        var splitted = createDateVulISO.split(" ")[0].split("-");
                        var createDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + createDateVulISO.split(" ")[1];
                        splitted = loginDateISO.split(" ")[0].split("-");
                        var loginDateLast = splitted[2] + "-" + splitted[1] + "-" + splitted[0] + " " + loginDateISO.split(" ")[1];
                        if (new Date(createDateLast).getTime() > new Date(loginDateLast).getTime()) {
                            $('td', row).css('background-color', '#C9CACE');
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    "language": {
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                        "processing": "<spring:message code="generic.tableLoading"/>",
                        "search": "<spring:message code="generic.search"/>  ",
                        "paginate": {
                            "next": "<spring:message code="generic.next"/>",
                            "previous": "<spring:message code="generic.back"/>"
                        },
                        "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                        "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    }

                });
            }

            function loadGroupedVulnTable() {
                blockUILoading();
                oTable4 = $('#groupedVulnTable').DataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "orderClasses": false,
                    "serverSide": true,
                    "bFilter": false,
                    "stateSave": true,
                    "scrollX": true,
                    "columns": [
                        {
                            "className": 'details-control',
                            "orderable": false,
                            "data": null,
                            "defaultContent": ''
                        },
                        {"data": 'name', "searchable": false, "orderable": false},
                        {"className": 'groupBarsStyle', "data": function (data) {
                                var closedCount = data.statusCounts[1];
                                var closedPercentage = Math.floor(closedCount * 100 / data.vulnerabilityCount);
                                var openPercentage = 100 - closedPercentage;
                                return '<div>' + '<div class="col-lg-3"><i class="fas fa-bug" style="font-size:20px;color:#4B0000"></i>' + "&nbsp;&nbsp;<b style='font-size:17px;color:#4B0000'>" + data.vulnerabilityCount + "</b>&nbsp;&nbsp;<text style='color:#4B0000'><spring:message code="vulnerability.title"/></text></div>"
                                        +
                                        '<div class="col-lg-3"><i class="far fa-calendar-plus" style="font-size:20px;color:#004B00"></i>' + "&nbsp;&nbsp;<b style='font-size:17px;color:#004B00'>" + data.ticketCount + "</b>&nbsp;&nbsp;<text style='color:#004B00'><spring:message code="addTicket.ticket"/></text></div>"
                                        +
                                        '<div class="col-lg-3"><i class="far fa-user" style="font-size:20px;color:#00004B"></i>' + "&nbsp;&nbsp;<b style='font-size:17px;color:#00004B'>" + data.assigneeCount + "</b>&nbsp;&nbsp;<text style='color:#00004B'><spring:message code="addVulnerability.assignee"/></text></div>"
                                        +
                                        '<div class="col-lg-3"><i class="fas fa-database" style="font-size:20px;color:#4B4B4B"></i>' + "&nbsp;&nbsp;<b style='font-size:17px;color:#4B4B4B'>" + data.assetCount + "</b>&nbsp;&nbsp;<text style='color:#4B4B4B'><spring:message code="dashboard.assetsCount"/></text></div></div>\n\
                                        <div style=''><div style='display:inline;float:left;background-color:#AAC8FF;width:" + closedPercentage + "%;min-height:6px;border-radius:5px'></div><div style='display:inline;float:left;background-color:#FFA5A5;width:" + openPercentage + "%;min-height:6px;border-radius:5px'></div></div>";
                            }, "searchable": false, "orderable": false},
                        {"className": 'groupCreatedStyle', "data": 'createdBy', "searchable": false, "orderable": false},
                        {"className": 'groupCreatedStyle', "data": 'createDate', "searchable": false, "orderable": false},
                        {"className": 'groupActionsStyle', "data": function (data) {
                                if(data.ticketGroupId === null){
                                    return "";
                                } else {
                                var html = '<button onClick="editTicketGroup(\'' + data.ticketGroupId + '\')" name="edit" type="button" class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="left" title="<spring:message code="generic.edit"/>"> <i class="fas fa-pen-square"></i>  </button>  ';
                                if (data.vulnerabilityCount === 0) {
                                    html += '<button onClick="deleteTicketGroup(\'' + data.ticketGroupId + '\')" name="delete" type="button" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="left" title="<spring:message code="generic.delete"/>"><i class="fas fa-times"></i></button>';
                                
                                }
                                else{
                                    html +='<button onClick="deleteTicketGroupRelations(\'' + data.ticketGroupId + '\')" name="removeFromGroups" type="button" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="listVuln.DeleteMultiGroup"/>"><i class="fas fa-times"></i></button>';

                                }
                                return html;
                                }
                            }, "searchable": false, "orderable": false}
                    ],
                    "order": [4, 'asc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadVulnerabilityGroups.json",
                        data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                             
                        },
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }
                       
                    },
                    "fnDrawCallback": function (oSettings) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    "initComplete": function (settings, json) {
                        $('#groupedVulnTable').DataTable().columns.adjust().draw();
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                         unBlockUILoading();
                    },
                    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        $('td', nRow).css('background-color', 'white');
                    },
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
                    }

                });
                $('#groupedVulnTable').DataTable().columns.adjust().draw();
               
            }

            function getVulCounts() {
                var obj = getObjectByForm("searchForm");
                obj["newVulnerabilities"] = newVulnerabilities;
                obj["searchBox"] = $('#searchBox').val();
                $.ajax({
                    "type": "POST",
                    "url": "loadVulnerabilityCounts.json",
                    "success": function (result) {
                        $("#tabAllHeader").html('<spring:message code="listVulnerabilities.allVulnerabilities"/>' + ' (' + result[0] + ')');
                        $("#tabNewHeader").html('<spring:message code="listVulnerabilities.newVulnerabilities"/>' + ' (' + result[1] + ')');
                        $("#tabClosedHeader").html('<spring:message code="listVulnerabilities.closedVulnerabilities"/>' + ' (' + result[2] + ')');
                        $("#tabArchivedHeader").html('<spring:message code="listVulnerabilities.archivedVulnerabilities"/>' + ' (' + result[3] + ')');
                    },
                    "data": obj,
                    "error": function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }
                    }
                });
            }
            function getStatusGraph() {
                document.getElementById("statusGraph").innerHTML = '';
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["newVulnerabilities"] = newVulnerabilities;
                obj["searchBox"] = $('#searchBox').val();
                obj["currentTab"] = currentTab;
                $.ajax({
                    "type": "POST",
                    "url": "loadVulnerabilityStatusGraph.json",
                    "success": function (result) {
                        temp = result;
                        var combined = [];
                        combined[0] = {"status": decodeHtml("<spring:message code="genericdb.OPEN"/>"), "color": '#67B7DC', "value": temp[0]};
                        combined[1] = {"status": decodeHtml("<spring:message code="genericdb.CLOSED"/>"), "color": '#FDD400', "value": temp[1]};
                        combined[2] = {"status": decodeHtml("<spring:message code="genericdb.RISK_ACCEPTED"/>"), "color": '#84B761', "value": temp[2]};
                        combined[3] = {"status": decodeHtml("<spring:message code="genericdb.RECHECK"/>"), "color": '#CC4748', "value": temp[3]};
                        combined[4] = {"status": decodeHtml("<spring:message code="genericdb.ON_HOLD"/>"), "color": '#CD82AD', "value": temp[4]};
                        combined[5] = {"status": decodeHtml("<spring:message code="genericdb.IN_PROGRESS"/>"), "color": '#2F4074', "value": temp[5]};
                        combined[6] = {"status": decodeHtml("<spring:message code="genericdb.FALSE_POSITIVE"/>"), "color": '#006400', "value": temp[6]};

                        $('#statusGraph').css("line-height", "");
                        statusGraphFunction(combined);
                    },
                    "data": obj,
                    "error": function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }
                    }
                });
            }
            function getRiskLevelGraph() {
                document.getElementById("riskLevelGraph").innerHTML = '';
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["newVulnerabilities"] = newVulnerabilities;
                obj["searchBox"] = $('#searchBox').val();
                obj["currentTab"] = currentTab;
                $.ajax({
                    "type": "POST",
                    "url": "loadVulnerabilityRiskLevelGraph.json",
                    "success": function (result) {
                        temp = result;
                        var combined = [];
                        combined[0] = {"name": decodeHtml("<spring:message code="dashboard.level5"/>"), "value": temp[5]};
                        combined[1] = {"name": decodeHtml("<spring:message code="dashboard.level4"/>"), "value": temp[4]};
                        combined[2] = {"name": decodeHtml("<spring:message code="dashboard.level3"/>"), "value": temp[3]};
                        combined[3] = {"name": decodeHtml("<spring:message code="dashboard.level2"/>"), "value": temp[2]};
                        combined[4] = {"name": decodeHtml("<spring:message code="dashboard.level1"/>"), "value": temp[1]};
                        combined[5] = {"name": decodeHtml("<spring:message code="dashboard.level0"/>"), "value": temp[0]};

                        $('#riskLevelGraph').css("line-height", "");
                        riskLevelGraphFunction(combined);
                    },
                    "data": obj,
                    "error": function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }
                    }
                });
            }

            function getAssetGraph() {
                document.getElementById("assetGraph").innerHTML = '';
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["newVulnerabilities"] = newVulnerabilities;
                obj["searchBox"] = $('#searchBox').val();
                obj["currentTab"] = currentTab;
                $.ajax({
                    "type": "POST",
                    "url": "loadAssetVulnerabilityCountGraph.json",
                    "success": function (result) {
                        temp = result;
                        var combined = [];
                        for (var i = 0; i < temp.length; i++) {
                            combined[i] = {"asset": decodeHtml(temp[temp.length-i-1].ip), "color": '#F9FABB', "closedVulnerabilityCount": temp[temp.length-i-1].closedVulnerabilityCount, "level5": temp[temp.length-i-1].level5, "level4": temp[temp.length-i-1].level4, "level3": temp[temp.length-i-1].level3, "level2": temp[temp.length-i-1].level2, "level1": temp[temp.length-i-1].level1};
                        }
                        $('#assetGraph').css("line-height", "");
                        assetLevelGraphFunction(combined);
                    },
                    "data": obj,
                    "error": function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }
                    }
                });
            }
            function deleteRow(id, deletedElement) {
                function confirmDelete() {
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteVulnerability.json", {scanVulnerabilityId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        oTable.api().draw();
                        oTable2.api().draw();
                        oTable3.api().draw();
                        oTable5.api().draw();
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listVulnerabilities.deleteFail"/>");
                        $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });
                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listVulnerabilities.confirmDelete"/>"), confirmDelete);
            }
            function downloadProofSingle(scanVulId, vulName) {
                $.post("downloadProofFile.json", {scanVulnerabilityId: scanVulId, vulnerabilityName: vulName, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function () {

                }).fail(function () {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVulnerabilities.downloadProofFail"/>");
                    $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                    $("#alertModal").modal("show");
                });
            }
            function openReportTypeModal() {
                getStatusGraph();
                getRiskLevelGraph();
                getAssetGraph();
                $('#selectReportType').modal('show');
            }
            function closeReportTypeModal() {
                $('#reportName').val("");
                $('#reportType').val('<spring:message code="listVulnerabilities.pdf"/>');
                document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                $('#selectReportType').modal('hide');
            }


            var type;


            function showActionModals(option) {
                type = option;
                var div = document.getElementById('info');
                $('#description').val("");
                switch (option) {
                    case "-1":
                        $('#actionModal').modal('hide');
                        $('#info').hide();
                        break;
                    case "1":
                        $('#multiVulnerabilityAssigneeChangeModal').modal();
                        break;
                    case "2":
                        $('#multiVulnerabilityStatusChangeModal').modal();
                        $("#selectForm").val("1");
                        $("#fileUploadTable").hide();
                        $("#fileUploadButtonPanel").show();
                        $("#fileUploadDiv").hide();
                        $('#statusDeadlineDiv').hide();
                        $('#statusDeadline').val('');
                        break;
                    case "3" :
                        $('#multiVulnerabilityDeleteModal').modal();
                        break;
                    case "4":
                        $('#multiVulnerabilityParametersChangeModal').modal();
                        break;
                    case "5":
                        $('#multiVulnerabilityDownloadProofFileModal').modal();
                        break;
                    case "6" :
                        $('#multiVulnerabilityArchiveModal').modal();
                        break;
                }
            }
            $(function () {
                $('#daterange').daterangepicker({
                    autoUpdateInput: false,
                    locale: {
                        cancelLabel: 'Clear'
                    }
                });
                $('#daterange').on('apply.daterangepicker', function (ev, picker) {
                    $(this).val(picker.startDate.format('DD.MM.YYYY') + '-' + picker.endDate.format('DD.MM.YYYY'));
                });
                $('#daterange').on('cancel.daterangepicker', function (ev, picker) {
                    $(this).val('');
                });
            });

            function reportTypeChanged() {
                var reportType = document.getElementById("reportType").value;
                switch (reportType) {
                    case '<spring:message code="listVulnerabilities.pdf"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                        break;
                    case '<spring:message code="listVulnerabilities.html"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.html</b>';
                        break;
                    case '<spring:message code="listVulnerabilities.csv"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.csv</b>';
                        break;
                    case '<spring:message code="listVulnerabilities.excel"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.xslx</b>';
                        break;
                    case '<spring:message code="listVulnerabilities.word"/>':
                        document.getElementById("reportExtension").innerHTML = '<b>.docx</b>';
                        break;
                    default:
                        document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                        break;

                }
            }
            
            function openVulnerabilityScanModal() {
                $('#vulnerabilityScan').modal('show');
            }
            
            function sendVulnerabilitiesToScan() {
                $('#vulnerabilityScan').modal('hide');
                blockUILoading();
                var vulIds = new Array();
                loadDataByTabForParameters(vulIds);
                $("#alertModalBody").empty();
                $.post("sendVulnerabilitiesToScan.json", {
                    ${_csrf.parameterName}: "${_csrf.token}",
                    "timePeriod": $("#timePeriod").val(),
                    "vulIds": vulIds             
                }).done(function (data, textStatus, jqXHR) {
                    if (jqXHR.status === 204) {
                        $("#alertModalBody").html("<spring:message code="listVulnerabilities.nonCheckRecords"/>");
                    } else if(jqXHR.status === 206) {
                        $("#alertModalBody").html("<spring:message code="listQualysScans.ipLimit.exceeded"/>");  
                    } else {
                        $("#alertModalBody").html(data.message);                         
                    }
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    } else {
                        $("#alertModalBody").html("<spring:message code="listQualysScans.scan.failed"/>");  
                    }
                }).always(function () {
                    $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                    $("#alertModal").modal("show");
                    unBlockUILoading();

                });
            }

            var vulnIdsForGroup = [];
            var ticketGroupList = [];
            function groupSelectedVulnerabilities() {

                $.post("getExistingTicketGroups.json", {
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (result) {
                    ticketGroupList = [];
                    $.each(result, function (i, val) {
                        ticketGroupList.push({id: val.name, text: val.name});
                    });
                    $("#groupName").select2({
                        data: ticketGroupList,
                        tags: true
                    });

                });

                vulnIdsForGroup = [];
                $('[id=checkVulnerability]:checked').each(function () {
                    vulnIdsForGroup.push($(this).val());
                });
                if (vulnIdsForGroup.length > 0) {
                    $('#vulnerabilityGroupModal').modal();
                } else {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVulnerabilities.selectWarning"/>");
                    $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                    $("#alertModal").modal("show");
                }
            }

            function groupVulnerabilities() {
                var groupName = $('#groupName').val();
                if (groupName === "" || groupName === null) {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVulnerabilities.pickOrAddWarning"/>");
                    $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                    $("#alertModal").modal("show");
                } else {
                    $.post("groupVulnerabilities.json", {
                        'vulnIds[]': vulnIdsForGroup,
                        'groupName': groupName,
            ${_csrf.parameterName}: "${_csrf.token}"
                    }).done(function (result) {
                        if (result.status === "success") {
                            if (result.alreadyAddedCount === 0) {
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listVulnerabilities.addedToGroup1"/>" + result.successCount);
                                $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                $("#alertModal").modal("show");
                            } else {
                                function updateGroupedVulnerabilities(){
                                    $.post("updateGroupedVulnerabilities.json", {
                                        'vulnIds[]': vulnIdsForGroup,
                                        'groupName': groupName,
                                        ${_csrf.parameterName}: "${_csrf.token}"
                                    }).done(function (result){
                                        if (result.status === "error") {
                                            $("#alertModalBody").empty();
                                            $("#alertModalBody").html("<spring:message code="listVuln.groupalert2"/>");
                                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                            $("#alertModal").modal("show");
                                        } else if(result.status === "success"){
                                            $("#alertModalBody").empty();
                                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.addedToGroup4"/>" + result.updatedCount);
                                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                                            $("#alertModal").modal("show");
                                        }
                                    });
                                };
                                jsInformationOkCancelModalFunction(
                                    "<spring:message code="listVulnerabilities.addedToGroup1"/>" 
                                        + result.successCount 
                                        + ". " 
                                        + "<spring:message code="listVulnerabilities.addedToGroup2"/>" 
                                        + result.alreadyAddedCount
                                        + ". " 
                                        + "<spring:message code="listVulnerabilities.addedToGroup3"/>" 
                                    ,updateGroupedVulnerabilities);
                            }
                        } else if (result.status === "empty") {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVuln.groupalert"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        } else if (result.status === "error") {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVuln.groupalert2"/>");
                            $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                            $("#alertModal").modal("show");
                        }
                    }).always(function () {
                        $('#vulnerabilityGroupModal').modal("hide");
                    });
                }

            }

            $('#groupedVulnTable').on('click', 'td.details-control', function () {
                var tr = $(this).closest('tr');
                var row = oTable4.row(tr);
                if (row.child.isShown()) {
                    row.child.hide();
                    tr.removeClass('shown');
                } else {
                    $.ajax({
                        type: "POST",
                        url: "getVulnerabilitiesOfGroup.json",
                        "data": {
                            '${_csrf.parameterName}': "${_csrf.token}",
                            'groupId': row.data().ticketGroupId
                        },
                        success: function (result) {
                            row.child(format(result, row)).show();
                            tr.addClass('shown');
                            // seviyeye göre dağılım
                            chartdiv = am4core.create("ticketGroupLevels" + row.data().ticketGroupId, am4charts.PieChart3D);
                            chartdiv.hiddenState.properties.opacity = 0; // this creates initial fade-in
                            chartdiv.innerRadius = am4core.percent(40);
                            chartdiv.depth = 20;
                            var pieSeries = chartdiv.series.push(new am4charts.PieSeries3D());
                            pieSeries.dataFields.value = "value";
                            pieSeries.dataFields.category = "name";
                            pieSeries.dataFields.depthValue = "value";
                            pieSeries.innerRadius = am4core.percent(40);
                            pieSeries.ticks.template.disabled = true;
                            pieSeries.labels.template.disabled = true;
                            pieSeries.slices.template.cornerRadius = 5;
                            pieSeries.colors.list = [
                                new am4core.color('#D91E18'),
                                new am4core.color('#F88008'),
                                new am4core.color('#F8C508'),
                                new am4core.color('#FEFE60'),
                                new am4core.color('#F9FABB'),
                                new am4core.color('#67B7DC')
                            ];
                            pieSeries.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                            pieSeries.slices.template.interactionsEnabled = true;
                            chartdiv.legend = new am4charts.Legend();
                            var legendContainer = am4core.create("ticketGroupLevelsLegend" + row.data().ticketGroupId, am4core.Container);
                            legendContainer.width = am4core.percent(100);
                            legendContainer.height = am4core.percent(100);
                            chartdiv.legend.parent = legendContainer;
                            chartdiv.legend.scale = 0.6;
                            chartdiv.legend.fontSize = 18;
                            chartdiv.scale = 1.1;
                            var combined = [];
                            combined[0] = {"name": "<spring:message code="dashboard.level5"/>", "status": "<spring:message code="dashboard.level5"/>", "value": row.data().levelCounts[5]};
                            combined[1] = {"name": "<spring:message code="dashboard.level4"/>", "status": "<spring:message code="dashboard.level4"/>", "value": row.data().levelCounts[4]};
                            combined[2] = {"name": "<spring:message code="dashboard.level3"/>", "status": "<spring:message code="dashboard.level3"/>", "value": row.data().levelCounts[3]};
                            combined[3] = {"name": "<spring:message code="dashboard.level2"/>", "status": "<spring:message code="dashboard.level2"/>", "value": row.data().levelCounts[2]};
                            combined[4] = {"name": "<spring:message code="dashboard.level1"/>", "status": "<spring:message code="dashboard.level1"/>", "value": row.data().levelCounts[1]};
                            combined[5] = {"name": "<spring:message code="dashboard.level0"/>", "status": "<spring:message code="dashboard.level0"/>", "value": row.data().levelCounts[0]};
                            chartdiv.data = combined;
                            // duruma göre dağılım
                            chartdiv2 = am4core.create("ticketGroupStatuses" + row.data().ticketGroupId, am4charts.PieChart3D);
                            chartdiv2.hiddenState.properties.opacity = 0; // this creates initial fade-in
                            chartdiv2.innerRadius = am4core.percent(40);
                            chartdiv2.depth = 20;
                            var pieSeries2 = chartdiv2.series.push(new am4charts.PieSeries3D());
                            pieSeries2.dataFields.value = "value";
                            pieSeries2.dataFields.category = "name";
                            pieSeries2.dataFields.depthValue = "value";
                            pieSeries2.innerRadius = am4core.percent(40);
                            pieSeries2.ticks.template.disabled = true;
                            pieSeries2.labels.template.disabled = true;
                            pieSeries2.slices.template.cornerRadius = 5;
                            pieSeries2.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                            pieSeries2.slices.template.interactionsEnabled = true;
                            chartdiv2.legend = new am4charts.Legend();
                            var legendContainer = am4core.create("ticketGroupStatusesLegend" + row.data().ticketGroupId, am4core.Container);
                            legendContainer.width = am4core.percent(100);
                            legendContainer.height = am4core.percent(100);
                            chartdiv2.legend.parent = legendContainer;
                            chartdiv2.legend.scale = 0.6;
                            chartdiv2.legend.fontSize = 18;
                            chartdiv2.scale = 1.1;
                            var combined = [];
                            combined[0] = {"name": "<spring:message code="genericdb.OPEN"/>", "status": "<spring:message code="genericdb.OPEN"/>", "value": row.data().statusCounts[0]};
                            combined[1] = {"name": "<spring:message code="genericdb.CLOSED"/>", "status": "<spring:message code="genericdb.CLOSED"/>", "value": row.data().statusCounts[1]};
                            combined[2] = {"name": "<spring:message code="genericdb.RISK_ACCEPTED"/>", "status": "<spring:message code="genericdb.RISK_ACCEPTED"/>", "value": row.data().statusCounts[2]};
                            combined[3] = {"name": "<spring:message code="genericdb.RECHECK"/>", "status": "<spring:message code="genericdb.RECHECK"/>", "value": row.data().statusCounts[3]};
                            combined[4] = {"name": "<spring:message code="genericdb.ON_HOLD"/>", "status": "<spring:message code="genericdb.ON_HOLD"/>", "value": row.data().statusCounts[4]};
                            combined[5] = {"name": "<spring:message code="genericdb.IN_PROGRESS"/>", "status": "<spring:message code="genericdb.IN_PROGRESS"/>", "value": row.data().statusCounts[5]};
                            combined[6] = {"name": "<spring:message code="genericdb.FALSE_POSITIVE"/>", "status": "<spring:message code="genericdb.FALSE_POSITIVE"/>", "value": row.data().statusCounts[6]};
                            chartdiv2.data = combined;
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                        }
                    });
                }
            });
            function format(detail, row) {
                var vulnerabilityTable = '<div><div class="col-lg-3"><br><br><div class="col-lg-6"><div id="ticketGroupLevelsLegend' + row.data().ticketGroupId + '"></div><br><br><div id="ticketGroupStatusesLegend' + row.data().ticketGroupId + '"></div></div><div class="col-lg-6"><div id="ticketGroupLevels' + row.data().ticketGroupId + '" style="margin: 0 auto"></div><br><br><div id="ticketGroupStatuses' + row.data().ticketGroupId + '" style="margin: 0 auto"></div></div></div><div class="col-lg-9" style="overflow-x:auto;">'+
                '<table id="altTable" class="table blue-bordered" style="width:100%;overflow-x: auto;">' +
                        
                        '<th width="10px"><input type="checkbox" class="editor-active" id="selectAll4'+ row.data().ticketGroupId +'" onclick="selectAll2('+'\'selectAll4'+ row.data().ticketGroupId+'\''+','+'\'checkVulnerabilityGroup'+ row.data().ticketGroupId+'\''+');" ></th> ' +
                    <c:if test="${groupedVulnTable.riskScore}">
                        '    <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="dashboard.riskScoreName"/></th> ' +                                                   
                    </c:if>
                    <c:if test="${sessionScope.performanceScoreActive}">                        
                    <c:if test="${groupedVulnTable.performanceScore}">
                        '    <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="viewVulnerability.performanceScore"/></th> ' +                                               
                    </c:if>          
                    <c:if test="${groupedVulnTable.vprScore}">
                        '    <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="viewVulnerability.vprScore"/></th> ' +                                                 
                    </c:if> 
                    </c:if>     
                    <c:if test="${groupedVulnTable.vulnerabilityName}">
                        '    <th style="vertical-align: middle; min-width: 200px;"><spring:message code="listVulnerabilities.name"/></th> ' +                                                 
                    </c:if>            
                    <c:if test="${groupedVulnTable.scanName}">
                        '    <th style="vertical-align: middle;"><spring:message code="scanNameAndSource"/></th> ' +                                               
                    </c:if>            
                    <c:if test="${groupedVulnTable.ip}">
                        '    <th style="vertical-align: middle;"><spring:message code="listVulnerabilities.asset"/></th> ' +                                               
                    </c:if>           
                    <c:if test="${groupedVulnTable.status}">
                        '    <th style="vertical-align: middle; min-width: 150px;" width="50px">><spring:message code="listVulnerabilities.status"/>/<spring:message code="viewVulnerability.responsible"/></th> ' +                                           
                    </c:if>       
                    <c:if test="${groupedVulnTable.port}">
                        '    <th style="vertical-align: middle; min-width: 40px;" width="80px"><spring:message code="listVulnerabilities.port"/></th> ' +                                               
                    </c:if>        
                    <c:if test="${groupedVulnTable.virtualHost}">
                        '    <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="addVirtualHost.host"/></th> ' +                                                
                    </c:if>         
                    <c:if test="${groupedVulnTable.label}">
                        '    <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="listTags.title"/></th> ' +                                               
                    </c:if> 
                    <c:if test="${groupedVulnTable.riskLevel}">
                        '    <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="listVulnerabilities.riskLevel"/></th> ' +                                                 
                    </c:if>     
                    <c:if test="${groupedVulnTable.createDate}">
                        '    <th style="vertical-align: middle; min-width: 110px;" width="110px"><spring:message code="listVulnerabilities.creationDate"/></th> ' +                                              
                    </c:if>         
                    <c:if test="${groupedVulnTable.updateDate}">
                        '    <th style="vertical-align: middle; min-width: 130px;white-space:pre-wrap; word-wrap:break-word" width="130px"><spring:message code="listVulnerabilities.lastUpdate"/></th> ' +                                               
                    </c:if>           
                        '    <th ><spring:message code="listVulnerabilities.removeFromGroup"/></th> ' +
                        '</tr>' +
                        '#replace#' +
                        '</table></div>';
                var vulnerabilityList = '';
                $.each(detail, function (i, val) {
                    var value = "";
                    vulnerabilityList += '<tr id="red">';
                    vulnerabilityList += '<td><input type="checkbox" class="editor-active" id="checkVulnerabilityGroup'+row.data().ticketGroupId+'" value="' + val.ticket.ticketId + '" >  </td>';
                <c:if test="${groupedVulnTable.riskScore}">
                    vulnerabilityList += '<td>#replace#</td>';
                    value = getRiskScore(val.riskScore);
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                 
                </c:if>    
                <c:if test="${sessionScope.performanceScoreActive}"> 
                <c:if test="${groupedVulnTable.performanceScore}">
                    vulnerabilityList += '<td>#replace#</td>';
                    var score;
                    if(val.performanceScore === -1) {
                        score = 0;
                    } else {
                        score = val.performanceScore;
                    }                                
                    value = '<div style="margin:auto;width:70px;text-align:center;padding-top:3px;height:25px;background-color:#AADBF9;border-radius:5px" ><b>' + score + '</b></div>';
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                              
                </c:if>
                <c:if test="${groupedVulnTable.vprScore}">
                    vulnerabilityList += '<td>#replace#</td>';
                    value = getVprScore(val);
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                
                </c:if>    
                </c:if>       
                <c:if test="${groupedVulnTable.vulnerabilityName}">
                    vulnerabilityList += '<td>#replace#</td>';
                    value = "<a href='viewVulnerability.htm?scanVulnerabilityId=" + val.scanVulnerabilityId + "'>" + encodeText(val.vulnerability.name) + "</a>";
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                
                </c:if>    
                <c:if test="${groupedVulnTable.scanName}">
                    vulnerabilityList += '<td>#replace#</td>';
                    var short;
                    if (val.scanName.length <= 15) {
                        short = decodeHtml(val.scanName);
                    } else {
                        short = decodeHtml(val.scanName).substring(0, 14) + '...';
                    }
                    value = getScannerLogoWithName(val.source,"${pageContext.request.contextPath}") + " " +'<span data-toggle="tooltip" data-placement="right" title="' + decodeHtml(val.scanName) + '" >&nbsp;' + encodeText(short) + '</span>';
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                 
                </c:if>
                <c:if test="${groupedVulnTable.ip}">
                    vulnerabilityList += '<td>#replace#</td>';
                    if(val.vulnerability.asset.assetType === 'VIRTUAL_HOST' 
                            && val.vulnerability.asset.otherIps !== null && val.vulnerability.asset.otherIps.length > 0) {
                        value = encodeText(val.vulnerability.asset.otherIps[0]);
                    } else {
                        if (val.vulnerability.asset.hostname === null || val.vulnerability.asset.hostname === '' || val.vulnerability.asset.hostname === undefined) {
                            value = encodeText(val.vulnerability.asset.ip);
                        } else {
                            value = '<div>' + encodeText(val.vulnerability.asset.ip) + ' <b>(' + encodeText(val.vulnerability.asset.hostname) + ')</b>' + ' </div>';
                        }
                    }
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                 
                </c:if>          
                <c:if test="${groupedVulnTable.status}">
                    vulnerabilityList += '<td>#replace#</td>';
                    if(val.ticket.ticketStatus.name === 'OPEN'){
                        value ='<div class="list_vulnerability_open" ><p size=5 color="black"><b>⚠ '+ val.ticket.ticketStatus.languageText +'</b><br/></p></div>';
                    } else if(val.ticket.ticketStatus.name === 'IN_PROGRESS'){
                        value = '<div class="list_vulnerability_in_progress"><p size=5 color="black"><b>⌛ '+ val.ticket.ticketStatus.languageText +'</b><br/></p></div>';
                    } else if(val.ticket.ticketStatus.name === 'ON_HOLD'){
                        value = '<div class="list_vulnerability_on_hold"><p size=4 color="black"><b>⛔ '+ val.ticket.ticketStatus.languageText +'</b><br/></p></div>';
                    } else if(val.ticket.ticketStatus.name === 'RECHECK'){
                        value = '<div class="list_vulnerability_recheck"><p size=5 color="black"><b>🔃 '+ val.ticket.ticketStatus.languageText +'</b><br/></div>';
                    } else if(val.ticket.ticketStatus.name === 'RISK_ACCEPTED'){
                        value = '<div <div class="list_vulnerability_risk_accepted"><p size=5 color="black"><b>🔀 '+ val.ticket.ticketStatus.languageText +'</b><br/></div>';
                    } else if(val.ticket.ticketStatus.name === 'CLOSED'){
                        value = '<div class="list_vulnerability_closed"><p size=5 color="black"><b>✔ '+ val.ticket.ticketStatus.languageText +'</b><br/></div>';
                    } else if(data.ticket.ticketStatus.name === 'FALSE_POSITIVE'){
                        value = '<div class="list_vulnerability_false_positive"><p size=5 color="black"><b>➕ '+ val.ticket.ticketStatus.languageText +'</b><br/></div>';
                    }
                    if (val.ticket === null || val.ticket.assignee === null) {
                        value += '<div style="margin-left:50%"><font size="2" color="black"><i class="fas fa-minus"></i></font></div>';
                    } else{
                        value += '<div style="text-align:center"><font size="2" color="black">' + val.ticket.assigneeDatatableText+'</font></div>';
                    }
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                
                </c:if>    
                <c:if test="${groupedVulnTable.port}">
                    vulnerabilityList += '<td>#replace#</td>';
                    if (val.vulnerability.port.portNumber === null || val.vulnerability.port.portNumber === undefined) {
                        value = '<div><i class="fas fa-minus"></i></div>';
                    } else {
                        value = '<span style="float: left;">' + val.vulnerability.port.portNumber + '</span><span style="float: right;">  <b> (' + val.vulnerability.port.protocol + ')</b></span>';
                    }
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                              
                </c:if>
                <c:if test="${groupedVulnTable.virtualHost}">
                    vulnerabilityList += '<td>#replace#</td>';
                    if (val.vulnerability.host.name === null || val.vulnerability.host.name === undefined) {
                        value = '<div><i class="fas fa-minus"></i> </div>';
                    } else {
                        value = '<span style="float: left;">' + encodeText(val.vulnerability.host.name);
                    }
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                              
                </c:if>          
                <c:if test="${groupedVulnTable.label}">
                    vulnerabilityList += '<td>#replace#</td>';
                    if (val.vulnerability.labels !== null || val.vulnerability.labels.length !== 0) {
                        var labels = "";
                        for (var i = 0; i < val.vulnerability.labels.length; i++) {
                            for (var j = 0; j < labelsList.length; j++) {
                                var value = "'>' + decodeHtml(data.vulnerability.labels[i].name) + '<'";
                                if (decodeHtml(val.vulnerability.labels[i].name) === labelsList[j] && value.indexOf() === -1) {
                                    labels += labelsAndColors[j];
                                    break;
                                }
                            }
                        }
                        if (labels === "" || labels.length === 0) {
                            value = '<div ><i class="fas fa-minus"></i> </div>';
                        } else {
                            value = '<div >' + labels + ' </div>';
                        }
                    } else {
                        value = '<div ><i class="fas fa-minus"></i> </div>';
                    }
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                               
                </c:if>    
                <c:if test="${groupedVulnTable.riskLevel}">
                    vulnerabilityList += '<td>#replace#</td>';
                    value = "<div class='riskLevel" + val.vulnerability.riskLevel + " riskLevelCommon'>" + val.vulnerability.riskLevel + " (" + val.vulnerability.riskDescription + ")</div>";
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                             
                </c:if>
                <c:if test="${groupedVulnTable.createDate}">
                    vulnerabilityList += '<td>#replace#</td>';
                    value = val.createDate;
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);                                                
                </c:if>          
                <c:if test="${groupedVulnTable.updateDate}">
                    vulnerabilityList += '<td>#replace#</td>';
                    if (val.ticket.updateDate === null) {
                        value = '<div ><i class="fas fa-minus"></i> / <i class="fas fa-minus"></i> </div>';
                    } else {
                        if (val.ticket.ticketStatus.name === "CLOSED") {
                            value = '<div >' + val.ticket.closingDate + ' ' + val.ticket.closeUserDatatableText + '</div>';
                        } else {
                            value = '<div >' + val.ticket.updateDate + ' / <i class="fas fa-minus"></i></div>';
                        }
                    }
                    vulnerabilityList = vulnerabilityList.replace('#replace#', value);
                </c:if>    
                    vulnerabilityList += '<td>#replace#</td>';
                    if(row.data().ticketGroupId !== null){
                        value = '<button onClick="deleteTicketGroupRelation(\'' + val.ticket.ticketId + '\')" name="removeFromGroup" type="button" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title=""><i class="fas fa-times"></i></button>';
                        vulnerabilityList = vulnerabilityList.replace('#replace#', value);
                    } else {
                        value = '<div><i class="fas fa-minus"></i></div>';
                        vulnerabilityList = vulnerabilityList.replace('#replace#', value);
                    }

                    vulnerabilityList += '</tr>';
                });

                vulnerabilityTable = vulnerabilityTable.replace('#replace#', vulnerabilityList);
                return vulnerabilityTable;
            }

            function deleteTicketGroupRelation(ticketId) {
                $.post("removeVulnerabilityFromGroup.json", {
                    'ticketId': ticketId,
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (result) {
                    oTable4.ajax.reload();
                }).always(function () {

                });
            }
            function deleteTicketGroupRelations(groupId) {
                ticketIds = [];
                $('[id=checkVulnerabilityGroup'+groupId+']:checked').each(function () {
                    ticketIds.push($(this).val());
                });
                if(ticketIds.length>0){
                    $.post("removeVulnerabilitiesFromGroup.json", {
                        'ticketIds': ticketIds,
                        ${_csrf.parameterName}: "${_csrf.token}"
                    }).done(function (result) {
                        oTable4.ajax.reload();
                        }).always(function () {

                    });
                }
                else {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVuln.groupnotcheck"/>");
                    $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                    $("#alertModal").modal("show");
                }
            }
            var groupIdEdit = "";
            function editTicketGroup(groupId) {
                $('#editVulnerabilityGroupModal').modal();
                groupIdEdit = groupId;
            }

            function editVulnerabilityGroup() {
                $.post("editTicketGroup.json", {
                    'newName': $('#newTicketGroupName').val(),
                    'groupId': groupIdEdit,
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (result) {
                    if (result.status === "same") {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listVulnerabilities.sameGroupName"/>");
                        $("#alertModal .modal-footer").html('<button type="button" class="btn btn-primary" data-dismiss="modal"><spring:message code="generic.ok"/></button>');
                        $("#alertModal").modal("show");
                    }
                }).always(function () {
                    $('#editVulnerabilityGroupModal').modal("hide");
                    oTable4.ajax.reload();
                });
            }

            function deleteTicketGroup(groupId) {
                $.post("deleteTicketGroup.json", {
                    'groupId': groupId,
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (result) {
                    oTable4.ajax.reload();
                }).always(function () {

                });
            }
            $("#isTicketReport").change(function () {
                var items;
                if (this.checked) {
                    items = ["<spring:message code="listVulnerabilities.pdf"/>"];
                } else {
                    items = ["<spring:message code="listVulnerabilities.pdf"/>",
                        "<spring:message code="listVulnerabilities.html"/>",
                        "<spring:message code="listVulnerabilities.csv"/>",
                        "<spring:message code="listVulnerabilities.excel"/>",
                        "<spring:message code="listVulnerabilities.word"/>"];
                }
                var str = "";
                for (var item in items) {
                    str += "<option value=" + items[item] + ">" + items[item] + "</option>";
                }
                document.getElementById("reportType").innerHTML = str;
            });
            $("#isPCIReport").change(function () {
                var items;
                if (this.checked) {
                    items = ["<spring:message code="listVulnerabilities.pdf"/>",
                        "<spring:message code="listVulnerabilities.html"/>"];
                } else {
                    items = ["<spring:message code="listVulnerabilities.pdf"/>",
                        "<spring:message code="listVulnerabilities.html"/>",
                        "<spring:message code="listVulnerabilities.csv"/>",
                        "<spring:message code="listVulnerabilities.excel"/>",
                        "<spring:message code="listVulnerabilities.word"/>"];
                }
                var str = "";
                for (var item in items) {
                    str += "<option value=" + items[item] + ">" + items[item] + "</option>";
                }
                document.getElementById("reportType").innerHTML = str;
            });
            document.getElementById("archivedOption").style.display = 'block';
            document.getElementById("deleteOption").style.display = 'none';
            $('[href=#tab5default]').on('shown.bs.tab', function (e) {
                document.getElementById("archivedOption").style.display = 'none';
                document.getElementById("deleteOption").style.display = 'block';
            });
            $('[href=#tab1default]').on('shown.bs.tab', function (e) {
                document.getElementById("archivedOption").style.display = 'block';
                document.getElementById("deleteOption").style.display = 'none';
            });
            $('[href=#tab2default]').on('shown.bs.tab', function (e) {
                document.getElementById("archivedOption").style.display = 'block';
                document.getElementById("deleteOption").style.display = 'none';
            });
            $('[href=#tab3default]').on('shown.bs.tab', function (e) {
                document.getElementById("archivedOption").style.display = 'block';
                document.getElementById("deleteOption").style.display = 'none';
            });
            $('[href=#tab4default]').on('shown.bs.tab', function (e) {
                document.getElementById("archivedOption").style.display = 'block';
                document.getElementById("deleteOption").style.display = 'none';
            });
            
        </script>

    </jsp:attribute>

        <jsp:body>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/taskengine.min.css">
            <div class="row">
                <div class="col-lg-12">
                    <!-- /.panel-heading -->
                    <div class="portlet-body">
                        <div>
                            <div class="panel with-nav-tabs panel-default">
                                <div class="tabbable-custom nav justified" style="overflow:visible !important">

                                    <ul class="nav nav-tabs nav-justified">

                                        <li class="active" > <a onClick="updateCurrentTab('all');"  style="text-decoration:none;color:#428bca" href="#tab1default" data-toggle="tab" data-title="<spring:message code='allVulnerabilities.Tooltip'/>"><i id="tabAllHeader" style="font-style:inherit"> <spring:message code="listVulnerabilities.allVulnerabilities"/></i>&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></a></li>                                                                                   

                                        <li><a onClick="updateCurrentTab('new');"  style="text-decoration:none;color:#428bca" href="#tab2default" data-toggle="tab" data-title="<spring:message code='newVulnerabilities.Tooltip'/>"><i id="tabNewHeader" style="font-style:inherit"><spring:message code="listVulnerabilities.newVulnerabilities"/></i>&nbsp;&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></a></li>  

                                        <li><a onClick="updateCurrentTab('closed');"  style="text-decoration:none;color:#428bca" href="#tab3default" data-toggle="tab" data-title="<spring:message code='closedVulnerabilities.Tooltip'/>"><i id="tabClosedHeader" style="font-style:inherit"><spring:message code="listVulnerabilities.closedVulnerabilities"/></i>&nbsp;&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></a></li>

                                        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
                                            <li><a onClick="updateCurrentTab('grouped');"  style="text-decoration:none;color:#428bca" href="#tab4default" data-toggle="tab" data-title="<spring:message code='listVulnerabilities.groupInfo'/>"><i id="tabGroupedHeader" style="font-style:inherit"><spring:message code="listVulnerabilities.groupedVulnerabilities"/></i>&nbsp;&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></a></li>
                                        </sec:authorize>
                                        <li><a onClick="updateCurrentTab('archived');"  style="text-decoration:none;color:#428bca" href="#tab5default" data-toggle="tab" data-title="<spring:message code='listVulnerabilities.archivedVulnerabilitiesToolTip'/>"><i id="tabArchivedHeader" style="font-style:inherit"><spring:message code="listVulnerabilities.archivedVulnerabilities"/></i>&nbsp;&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></a></li>
                                    </ul>
                                </div>
                                <div class="panel-body">

                                    <div id="allRecords" style ="display: none">
                                        <input type="checkbox" class="editor-active" id="checkBoxAllRecords">
                                            <spring:message code="generic.checkAllRecordsText"/>   
                                    </div>

                                    <div class="tab-content">
                                        <div class="tab-pane fade in active" id="tab1default">
                                            <div>
                                                <table width="100%" class="table table-striped table-bordered table-hover" id="allVulnTable" style="width: 100% !important;">
                                                    <thead class="datatablesThead">
                                                        <tr>
                                                            <th width="10px"><input type="checkbox" class="editor-active" id="selectAll" onclick="allRecordsFunction();
                                                                    selectAll('checkVulnerability');" ></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="dashboard.riskScoreName"/></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="viewVulnerability.performanceScore"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="viewVulnerability.vprScore"/></th>
                                                        <th style="vertical-align: middle; min-width: 200px;"><spring:message code="listVulnerabilities.name"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="scanNameAndSource"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="listVulnerabilities.asset"/></th>
                                                        <th style="vertical-align: middle; min-width: 150px;" width="50px"><spring:message code="listVulnerabilities.status"/>/<spring:message code="viewVulnerability.responsible"/></th>                                     
                                                        <th style="vertical-align: middle; min-width: 40px;" width="80px"><spring:message code="listVulnerabilities.port"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="addVirtualHost.host"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="listTags.title"/></th>
                                                        <th style="vertical-align: middle; min-width: 100px;" width="100px"><spring:message code="listVulnerabilities.riskLevel"/></th>             
                                                        <th style="vertical-align: middle; min-width: 110px;" width="110px"><spring:message code="listVulnerabilities.creationDate"/></th>
                                                        <th style="vertical-align: middle; min-width: 130px;white-space:pre-wrap; word-wrap:break-word" width="130px"><spring:message code="listVulnerabilities.lastUpdate"/></th>
                                                        <th width="143px"><div style="min-width: 143px;"></div></th>  
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>                                                        
                                                        </tr>
                                                        </thead>                                
                                                </table> 
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="tab2default">
                                            <div>
                                                <table width="100%" class="table table-striped table-bordered table-hover" id="lastVulnTable" style="width: 100% !important;">
                                                    <thead class="datatablesThead">
                                                        <tr>
                                                            <th width="10px"><input type="checkbox" class="editor-active" id="selectAll2" onclick="allRecords2Function();
                                                                    selectAll2('selectAll2', 'checkVulnerabilityL');" ></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="dashboard.riskScoreName"/></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="viewVulnerability.performanceScore"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="viewVulnerability.vprScore"/></th>                                                        
                                                        <th style="vertical-align: middle; min-width: 200px;"><spring:message code="listVulnerabilities.name"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="scanNameAndSource"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="listVulnerabilities.asset"/></th>
                                                        <th style="vertical-align: middle; min-width: 150px;" width="50px"><spring:message code="listVulnerabilities.status"/>/<spring:message code="viewVulnerability.responsible"/></th>
                                                        <th style="vertical-align: middle; min-width: 40px;" width="80px"><spring:message code="listVulnerabilities.port"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="addVirtualHost.host"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="listTags.title"/></th>  
                                                        <th style="vertical-align: middle; min-width: 100px;" width="100px"><spring:message code="listVulnerabilities.riskLevel"/></th>             
                                                        <th style="vertical-align: middle; min-width: 110px;" width="110px"><spring:message code="listVulnerabilities.creationDate"/></th>
                                                        <th style="vertical-align: middle; min-width: 130px;white-space:pre-wrap; word-wrap:break-word" width="130px"><spring:message code="listVulnerabilities.lastUpdate"/></th>
                                                        <th width="143px"><div style="min-width: 143px;"></div></th>   
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>                                                        
                                                        </tr>
                                                        </thead>                                
                                                </table> 
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="tab3default">
                                            <div>
                                                <table width="100%" class="table table-striped table-bordered table-hover" id="closedVulnTable" style="width: 100% !important;">
                                                    <thead class="datatablesThead">
                                                        <tr>
                                                            <th width="10px"><input type="checkbox" class="editor-active" id="selectAll3" onclick="allRecords3Function();
                                                                    selectAll2('selectAll3', 'checkVulnerabilityC');" ></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="dashboard.riskScoreName"/></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="viewVulnerability.performanceScore"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="viewVulnerability.vprScore"/></th>                                                              
                                                        <th style="vertical-align: middle; min-width: 200px;"><spring:message code="listVulnerabilities.name"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="scanNameAndSource"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="listVulnerabilities.asset"/></th>
                                                        <th style="vertical-align: middle; min-width: 150px;" width="50px"><spring:message code="listVulnerabilities.status"/>/<spring:message code="viewVulnerability.responsible"/></th>                                    
                                                        <th style="vertical-align: middle; min-width: 40px;" width="80px"><spring:message code="listVulnerabilities.port"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="addVirtualHost.host"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="listTags.title"/></th>
                                                        <th style="vertical-align: middle; min-width: 100px;" width="100px"><spring:message code="listVulnerabilities.riskLevel"/></th>             
                                                        <th style="vertical-align: middle; min-width: 110px;" width="110px"><spring:message code="listVulnerabilities.creationDate"/></th>
                                                        <th style="vertical-align: middle; min-width: 130px;white-space:pre-wrap; word-wrap:break-word" width="130px"><spring:message code="listVulnerabilities.lastUpdate"/></th>
                                                        <th width="143px"><div style="min-width: 143px;"></div></th> 
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>                                                        
                                                        </tr>
                                                        </thead>                                
                                                </table> 
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="tab4default">
                                            <div>
                                                <div class="row" style="z-index:-1;">
                                                    <div class="col-lg-4" style="padding-left: 10px !important; padding-right: 3px !important;">
                                                        <div class="portlet light dark-index bordered shadow-soft" >
                                                            <div class="portlet-title portlet-title-black">
                                                                <div class="caption">
                                                                    <span class="caption-subject font-dark bold uppercase"><spring:message code="listVulnerabilities.vulnGroupCountGraph"/></span>
                                                                </div>
                                                            </div>
                                                            <div class="portlet-body portlet-body-black" style="height: 258px;">
                                                                <div class="col-md-5">
                                                                    <div id="vulnGroupCountGraphLegendDiv"></div>
                                                                </div>
                                                                <div class="col-md-7">
                                                                    <div id="vulnGroupCountGraph" style="width: 100%;height: 250px" ></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-4" style="padding-left: 3px !important; padding-right: 3px !important;">
                                                        <div class="portlet light dark-index bordered shadow-soft">
                                                            <div class="portlet-title portlet-title-black">
                                                                <div class="caption">
                                                                    <span class="caption-subject font-dark bold uppercase"><spring:message code="listVulnerabilities.vulnGroupStatusGraph"/></span>
                                                                </div>
                                                            </div>
                                                            <div class="portlet-body portlet-body-black" style="height: 258px;">
                                                                <div class="col-md-5">
                                                                    <div id="vulnGroupStatusGraphLegendDiv"></div>
                                                                </div>
                                                                <div class="col-md-7">
                                                                    <div id="vulnGroupStatusGraph" style="width: 100%;height: 250px" ></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-4" style="padding-left: 3px !important; padding-right: 10px !important;">
                                                        <div class="portlet light dark-index bordered shadow-soft">
                                                            <div class="portlet-title portlet-title-black">
                                                                <div class="caption">
                                                                    <span class="caption-subject font-dark bold uppercase"><spring:message code="listVulnerabilities.vulnGroupAssetGraph"/></span>
                                                                </div>
                                                            </div>
                                                            <div class="portlet-body portlet-body-black" style="height: 258px;">
                                                                <div class="col-md-5">
                                                                    <div id="vulnGroupAssetGraphLegendDiv"></div>
                                                                </div>
                                                                <div class="col-md-7">
                                                                    <div id="vulnGroupAssetGraph" style="width: 100%;height: 250px" ></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div><br>
                                                
                                                <table width="100%" class="table table-striped table-bordered table-hover dt-responsive" id="groupedVulnTable" style="width: 100% !important;">
                                                    <thead>
                                                        <tr>
                                                            <th></th>
                                                            <th><spring:message code="listAssetGroups.name"/></th>
                                                            <th><spring:message code="dashboard.alarmDetails"/></th>
                                                            <th><spring:message code="listReports.createdBy"/></th>
                                                            <th><spring:message code="listReports.createDate"/></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>                                
                                                </table> 
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="tab5default">
                                            <div>
                                                <table width="100%" class="table table-striped table-bordered table-hover" id="archivedVulnTable" style="width: 100% !important;">
                                                    <thead class="datatablesThead">
                                                        <tr>
                                                            <th width="10px"><input type="checkbox" class="editor-active" id="selectAll4" onclick="allRecords4Function();
                                                                    selectAll2('selectAll4', 'checkVulnerabilityC');" ></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="dashboard.riskScoreName"/></th>
                                                        <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="viewVulnerability.performanceScore"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="viewVulnerability.vprScore"/></th>                                                              
                                                        <th style="vertical-align: middle; min-width: 200px;"><spring:message code="listVulnerabilities.name"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="scanNameAndSource"/></th>
                                                        <th style="vertical-align: middle;"><spring:message code="listVulnerabilities.asset"/></th>
                                                        <th style="vertical-align: middle; min-width: 150px;" width="50px"><spring:message code="listVulnerabilities.status"/>/<spring:message code="viewVulnerability.responsible"/></th>                                    
                                                        <th style="vertical-align: middle; min-width: 40px;" width="80px"><spring:message code="listVulnerabilities.port"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="addVirtualHost.host"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="listTags.title"/></th>
                                                        <th style="vertical-align: middle; min-width: 100px;" width="100px"><spring:message code="listVulnerabilities.riskLevel"/></th>             
                                                        <th style="vertical-align: middle; min-width: 110px;" width="110px"><spring:message code="listVulnerabilities.creationDate"/></th>
                                                        <th style="vertical-align: middle; min-width: 130px;white-space:pre-wrap; word-wrap:break-word" width="130px"><spring:message code="listVulnerabilities.lastUpdate"/></th>
                                                        <th width="143px"><div style="min-width: 143px;"></div></th> 
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>                                                        
                                                        </tr>
                                                        </thead>                                
                                                </table> 
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal fade" id="selectReportType" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                        <div class="modal-dialog" style="width:25%">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <spring:message code="listVulnerabilities.reportType"/>
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
                                                            <input name="reportType" id="isPCIReport" type="checkbox"/>&nbsp;<spring:message code="listVulnerabilities.pciReport"/>
                                                        </div>
                                                        <div class="form-group">
                                                            <input name="reportType" id="isTicketReport" type="checkbox"/>&nbsp;<spring:message code="ticketReport.header"/>
                                                        </div>
                                                        <div class="form-group">
                                                            <label><spring:message code="listVulnerabilities.reportType"/></label>                                                   
                                                            <select id="reportType" class="selectpicker btn btn-sm btn-default btn-info dropdown-toggle" onchange="reportTypeChanged();" data-style="btn btn-info btn-sm">
                                                                <option value='<spring:message code="listVulnerabilities.pdf"/>'><spring:message code="listVulnerabilities.pdf"/></option>
                                                                <option value='<spring:message code="listVulnerabilities.html"/>'><spring:message code="listVulnerabilities.html"/></option>
                                                                <option value='<spring:message code="listVulnerabilities.csv"/>'><spring:message code="listVulnerabilities.csv"/></option>
                                                                <option value='<spring:message code="listVulnerabilities.excel"/>'><spring:message code="listVulnerabilities.excel"/></option>
                                                                <option value='<spring:message code="listVulnerabilities.word"/>'><spring:message code="listVulnerabilities.word"/></option>
                                                            </select>
                                                        </div>
                                                        <div class="form-group">
                                                            <p id="reportErrorPTag" style="color:red;visibility:hidden">
                                                                <br><b><spring:message code="report.reportNameValidation"/></b></p>        
                                                        </div>
                                                        <br>
                                                        <div class="modal-footer" id="download">
                                                            <div class="row">
                                                                <div class="row">
                                                                    <button type="buttonback" id="buttonback3" onclick="closeReportTypeModal();" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                                                    <button onClick="reportNameControl()" id="downloadReport" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal fade" id="vulnerabilityScan" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                        <div class="modal-dialog" style="width:25%">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <spring:message code="listVulnerabilities.vulnerabilityScan"/>
                                                </div>
                                                <div class="modal-body">                       
                                                    <div class="panel-body"> 
                                                        <div class="form-group">
                                                            <label><spring:message code="listVulnerabilities.vulnerabilityScanInfo"/></label>                                                   
                                                            <select id="timePeriod" class="selectpicker btn btn-sm btn-default btn-info dropdown-toggle" onchange="reportTypeChanged();" data-style="btn btn-info btn-sm">
                                                                <option value='0'><spring:message code="generic.dayTime"/></option>
                                                                <option value='1'><spring:message code="generic.nightTime"/></option>
                                                            </select>
                                                        </div>
                                                        <br>
                                                        <div class="modal-footer" id="download">
                                                            <div class="row">
                                                                <div class="row">
                                                                    <button type="buttonback" id="doNotStartScan" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                                                    <button onClick="sendVulnerabilitiesToScan()" id="startScan" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>                            
                                    <div class="modal fade" id="vulnerabilityGroupModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                        <div class="modal-dialog" style="width:25%">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <spring:message code="listVulnerabilities.grouping"/>
                                                </div>
                                                <div class="modal-body">                       
                                                    <div class="panel-body"> 
                                                        <div class="form-group required">
                                                            <label><spring:message code="listAssetGroups.name"/></label>
                                                            <div style="display:flex;">
                                                                <select class="js-example-tags form-control" id="groupName" style="width:80%;">
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <br>
                                                        <div class="modal-footer" id="groupNameButtons">
                                                            <div class="row">
                                                                <div class="row">
                                                                    <button type="buttonback" id="doNotConfirmGroup" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                                                    <button onClick="groupVulnerabilities()" id="groupVulnerabilitiesConfirm" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>       
                                            </div>  
                                        </div>
                                    </div>
                                    <div class="modal fade" id="editVulnerabilityGroupModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                        <div class="modal-dialog" style="width:25%">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <spring:message code="listVulnerabilities.groupEdit"/>
                                                </div>
                                                <div class="modal-body">                       
                                                    <div class="panel-body"> 
                                                        <div class="form-group required">
                                                            <label><spring:message code="generic.new"/> <spring:message code="listAssetGroups.name"/></label>
                                                            <div style="display:flex;">
                                                                <input class="form-control" id ="newTicketGroupName" maxlength="50" style="width:80%;">
                                                            </div>
                                                        </div>
                                                        <br>
                                                        <div class="modal-footer" id="">
                                                            <div class="row">
                                                                <div class="row">
                                                                    <button type="buttonback" id="doNotConfirmEdit" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                                                    <button onClick="editVulnerabilityGroup()" id="editVulnerabilityGroupConfirm" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>       
                                                </div>  
                                            </div>
                                        </div>
                                    </div>
                                </div>       
                            </div>  
                        </div>
                    </div>                     
                    <div class="modal fade" id="errorModal" role="dialog" aria-labelledby="modalLabel" aria-hidden="true" style="z-index:99999;">
                        <div class="modal-dialog" style="width:35%">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title"><spring:message code="generic.alert"/></h4>
                                </div>         
                                <div class="modal-body" id="errorModalBody">                       
                                      
                                </div>
                                <div class="modal-footer" style="text-align:center;">
                                    <button type="button" data-dismiss="modal"  class="btn btn-success"><spring:message code="generic.submit"/></button>
                                </div>
                            </div>
                        </div>                    
                    </div>
                    <sec:authorize access = "!hasRole('ROLE_PENTEST_ADMIN')">
                        <sec:authorize access = "!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">                                                                 
                            <jsp:include page="include/multiVulnerabilityAssigneeChangeModal.jsp" >
                                <jsp:param name="type" value="vulnerability"/>  
                            </jsp:include>
                            <jsp:include page="include/multiVulnerabilityStatusChangeModal.jsp" >
                                <jsp:param name="type" value="vulnerability"/>  
                            </jsp:include>
                            <jsp:include page="include/multiVulnerabilityParametersChangeModal.jsp" >
                                <jsp:param name="type" value="vulnerability"/>  
                            </jsp:include>
                            <jsp:include page="include/multiVulnerabilityDeleteModal.jsp" >
                                <jsp:param name="type" value="vulnerability"/>  
                            </jsp:include>
                            <jsp:include page="include/multiVulnerabilityArchiveModal.jsp" >
                                <jsp:param name="type" value="vulnerability"/>  
                            </jsp:include>
                            <jsp:include page="include/multiVulnerabilityDownloadProofFileModal.jsp" >
                                <jsp:param name="type" value="vulnerability"/>  
                            </jsp:include>
                            
                        </sec:authorize>                                               
                    </sec:authorize>   
                    <input type="hidden" id="scanVulIds" value=""/>
                    <style>
                        .badge {
                            font-size: 50px;
                        }
                        .dt-buttons {
                            margin-left: 5px; 
                            margin-top: 0px !important;
                            float: none !important;
                            display: inline;
                        }
                        .dataTables_length {
                            text-align: right;
                        }
                        .portlet.light {
                            padding: 8px 10px 0px !important;
                        }
                        #allVulnTable_processing
                        {
                         margin-top: -9.5%;      
                         z-index: 1200;              
                        }
                        #lastVulnTable_processing
                        {
                         margin-top: -9.5%;      
                         z-index: 1200;              
                        }
                        #closedVulnTable_processing
                        {
                         margin-top: -9.5%;      
                         z-index: 1200;              
                        }
                        #archivedVulnTable_processing
                        {
                         margin-top: -9.5%;      
                         z-index: 1200;              
                        }
                        #groupedVulnTable_processing
                        {
                         margin-top: -9.5%;      
                         z-index: 1200;              
                        }
                    </style>
                    </jsp:body>
                </biznet:mainPanel>
