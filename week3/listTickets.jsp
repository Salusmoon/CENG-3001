<%-- 
    Document   : listTickets
    Created on : 08/2017
    Author     : mustafa.ergan
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<biznet:mainPanel viewParams="title,body,search">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listTickets.title"/></span>
            </li>
        </ul>
    </jsp:attribute>

    <jsp:attribute name="search">
        <biznet:searchpanel tableType="ticketSearchDatatable" tableName="oTable">
            <div class="row" style="margin-bottom:1em; margin-left: 1px;">
                <label class="col-lg-1 control-label" ><b><spring:message code="listTickets.title"/></b></label>
                <div class="col-lg-2">
                    <select id ="ticketIds" name="ticketIds" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                        <c:forEach items="${ticketIds}" var="ticket">
                            <option value="${ticket.ticketId}"><c:out value="${ticket.ticketCustomerId}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.statuses"/></b></label>
                <div class="col-lg-2">
                    <select id ="statuses" name="statuses" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                        <c:forEach items="${statuses}" var="status">
                            <option value="${status.ticketStatusId}"><c:out value="${status.languageText}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <label class="col-lg-1 control-label" ><b><spring:message code="datatable.ticketPriority.languageText"/></b></label>
                <div class="col-lg-2">
                    <select id ="priorities" name="priorities" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                        <c:forEach items="${priorities}" var="priority">
                            <option value="${priority.ticketPriorityId}"><c:out value="${priority.languageText}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <div id="withVuln" style="width: 100%;display: block">
                    <label class="col-lg-1 control-label" ><b><spring:message code="datatable.assetName"/></b></label>
                    <div class="col-lg-2">
                        <input class="form-control" id ="ipAddress" name="ipAddress"  placeholder="">
                    </div>
                </div>
            </div>
            <div class="row" style="margin-bottom:1em;margin-left: 1px">
                <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.responsible"/></b></label>
                <div class="col-lg-2">
                    <jsp:include page="/WEB-INF/jsp/ticket/include/ticketUserAndGroup.jsp">
                        <jsp:param name="labelDontShow" value="false"/>
                        <jsp:param name="formName" value="assigneeIds"/>
                    </jsp:include>
                </div>

                <label class="col-lg-1 control-label" ><b><spring:message code="datatable.createUserDatatableText"/></b></label>
                <div class="col-lg-2">
                    <jsp:include page="/WEB-INF/jsp/ticket/include/ticketUserAndGroup.jsp">
                        <jsp:param name="labelDontShow" value="false"/>
                        <jsp:param name="formName" value="createdUser"/>
                    </jsp:include>
                </div>
                <label class="col-lg-1 control-label" ><b><spring:message code="datatable.createDate"/></b></label>
                <div class="col-lg-2">
                    <div class='input-group date' id='createDateDiv'>
                        <input name="createDate" class="form-control" id="createDate" readonly/>
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>
                <label class="col-lg-1 control-label" ><b><spring:message code="datatable.closedBy"/></b></label>
                <div class="col-lg-2">
                    <jsp:include page="/WEB-INF/jsp/ticket/include/ticketUserAndGroup.jsp">
                        <jsp:param name="labelDontShow" value="false"/>
                        <jsp:param name="groupDontShow" value="false"/>
                        <jsp:param name="formName" value="closedUser"/>
                    </jsp:include>
                </div>
            </div>
            <div class="row" style="margin-bottom:1em;margin-left: 1px">
                <label class="col-lg-1 control-label" ><b><spring:message code="datatable.closingDate"/></b></label>
                <div class="col-lg-2">
                    <div class='input-group date' id='closingDateDiv'>
                        <input name="closingDate" class="form-control" id="closingDate" readonly/>
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>
                <label class="col-lg-1 control-label" >
                	<b>
                		<spring:message code="filter.remainingSlaTime"/>
                		<input type="checkbox" id="remainingSlaChecked" name="remainingSlaChecked" style="float: right">
                	</b>
                </label>
                 <div class="col-lg-2">
                 	<div id="remainingSlaDiv">
                         <input type="text" id="remainingSlaTime" name="remainingSlaTime" class="text-center" readonly style="width:100%; border:0; color:#337ab7; font-weight:bold;">
                         <div id="remainingSlaSlider"></div>
                     </div>
                 </div>
            </div>                
        </biznet:searchpanel>
    </jsp:attribute>

    <jsp:attribute name="button" >
        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
            <a class="btn btn-primary btn-sm" href="addTicket.htm"><spring:message code="listTickets.addTicket"/></a>
            <a class="btn btn-default btn-sm" style="width: 90px;" onclick="openReportTypeModal()" aria-expanded="false">Raporla</a>
        </sec:authorize>
    </jsp:attribute>

    <jsp:attribute name="script">
        <style>
            .dt-buttons {
                margin-left: 5px; 
                margin-top: 0px !important;
                float: none !important;
                display: inline;
            }
            .dataTables_length {
                text-align: right;
            }

            #withVulnTicketTable_processing
            {
                margin-top: -8.5%;      
                z-index: 1200;              
            }
            #withoutVulnTicketTable_processing
            {
                margin-top: -8.5%;   
                z-index: 1200;              
            }
        </style>
        <script>
            document.title = "<spring:message code="main.theme.listTickets"/> - BIZZY";
            function actionDatatable(row, type) {
            	if (type === "update") {
            		window.location = "addTicket.htm?action=update&ticketId=" + row.ticketId;
           	 	} else if (type === "delete") {
		            $.ajax({
		            "type": "POST",
		                    "url": "deleteTicket.json" + "?${_csrf.parameterName}=${_csrf.token}" + "&ticketId=" + row.ticketId,
		                    "data": {
		                    '${_csrf.parameterName}': "${_csrf.token}",
		                            'taskId': row.ticketId
		                    },
		                    success: function (alert) {
		                    if (alert.control === true) {
		                    $("#alertModalBody").empty();
		                    $("#alertModalBody").text(alert.errorText);
		                    $("#alertModal").modal("show");
		                    } else {
		                    $('#withoutVulnTicketTable').DataTable().draw();
		                    }
		                    },
		                    error: function (jqXHR, textStatus, errorThrown) {
		                    ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
		                    }
		            });
		        } else if (type === "info") {
		            window.location = "viewTicket.htm?ticketId=" + row.ticketId;
		        }
            }
            $('#createDate').daterangepicker({
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
            $('#createDate').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('DD.MM.YYYY') + '-' + picker.endDate.format('DD.MM.YYYY'));
            });
            $('#createDate').on('cancel.daterangepicker', function (ev, picker) {
            $(this).val('');
            });
            $('#closingDate').daterangepicker({
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
            $('#closingDate').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('DD.MM.YYYY') + '-' + picker.endDate.format('DD.MM.YYYY'));
            });
            $('#closingDate').on('cancel.daterangepicker', function (ev, picker) {
            $(this).val('');
            });
            <%--Kalan SLA Süresi Filtresine ait gün seçim slideri--%>
            $("#remainingSlaSlider").slider({
            type: "single",
                    range: false,
                    min: 0,
                    max: 30,
                    values: [0],
                    slide: function(event, ui) {
                    $("#remainingSlaTime").val(ui.values[ 0 ]);
                    }
            });
            $("#remainingSlaTime").val($("#remainingSlaSlider").slider("values", 0));
            
            function openReportTypeModal() {
                $('#selectReportType').modal('show');
            }
            function closeReportTypeModal() {
                $('#reportName').val("");
                $('#reportType').val('<spring:message code="listVulnerabilities.pdf"/>');
                document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                $('#selectReportType').modal('hide');
            }
            reportNameControl = function () {
                var text = document.getElementById("reportName");
                if (!text.value || text.value.length === 0) {
                    document.getElementById("reportErrorPTag").style.display = "block";
                } else {
                    document.getElementById("reportErrorPTag").style.display = "none";
                    redirectReport();
                }
            }
            function redirectReport() {
                blockUILoading();
                var params = getObjectByForm("searchForm");
                    params["reportName"] = $('#reportName').val();
                    params["remainingSla"] = $("#remainingSla").val();
                    params["reportExtension"] = $('#reportType').val();
                generateReport("getTicketReport.json", params, "<spring:message code="report.reportCreation"/>",
                        "<spring:message code="listVulnerabilities.reportError"/>", "<spring:message code="listVulnerability.noData"/>");
                unBlockUILoading();
                closeReportTypeModal();
            }
            $(document).ready(function () {
            $(window).bind('resize', function () {
            if (oTable !== undefined)
                    oTable.fnAdjustColumnSizing();
            if (oTable2 !== undefined)
                    oTable2.fnAdjustColumnSizing();
            });
            getTicketCounts();
            $('#withVulnTicketTable').on('load', loadWithVulnTable());
            });
            $("[data-toggle=popover]").popover({container: 'body'});
            function actionRow(self, type, tableId) {
	            var tr = $(self).closest('tr');
	            var row = $("#" + tableId).dataTable().DataTable().row(tr);
	            actionDatatable(row.data(), type, tableId);
            }

            function returnWithVulnDataFunk() {
	            var html = '<div class="dropdown"><button class="btn dropdown-toggle btn-sm" type="button" data-toggle="dropdown" style="font-size: 11px;"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
	            html += '<li><a href="#" onClick="actionRow(this,\'info\',\'' + 'withVulnTicketTable' + '\')"><spring:message code="generic.detail"/></a></li>';
	            html += '</ul></div>';
	            /*html += '<a style=&quot;margin-left: 9px;&quot; onClick=&quot;actionRow(this,\'info\',\'' + 'withVulnTicketTable' + '\')&quot;><spring:message code="generic.detail"/></a>  ';
	             html += '<hr class=&quot;bizzy-hr-line&quot;/>';
	             html += '</div>"></a>';*/
	            return html;
            }

            function returnWithoutVulnDataFunk(data) {
            var html = '<div class="dropdown"><button class="btn dropdown-toggle btn-sm" type="button" data-toggle="dropdown" style="font-size: 11px;" ><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
            html += '<li><a  onclick="actionRow(this,\'info\',\'' + 'withoutVulnTicketTable' + '\')" ><spring:message code="generic.detail"/></a> </li>';
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
            if (data.linkValue.length === 0) {
            html += '<li><a  onclick="actionRow(this,\'update\',\'' + 'withoutVulnTicketTable' + '\')" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail.edit"/></a></li>  ';
            }
            html += '<li><a  onclick="actionRow(this,\'delete\',\'' + 'withoutVulnTicketTable' + '\')" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a></li>  ';
            </sec:authorize>
            html += '</ul></div>';
            return html;
            }

            var newTickets;
            if ("<c:out value="${status}"/>".length > 0) {
            if (decodeHtml('<c:out value="${status}"/>') === "OPEN") {
            $("#statuses").val(["1", "3", "4", "5", "6"]).trigger('change');
            } else if (decodeHtml('<c:out value="${status}"/>') === "CLOSED") {
            $("#statuses").val("2").trigger('change');
            }
            }
            if ("${date}".length > 0) {
            newTickets = "${date}";
            }

            function updateCurrentTab(tab) {
            currentTab = tab;
            switch (currentTab) {

            case 'withVuln':
                    document.getElementById("withVuln").style.display = 'block';
            $('#withVulnTicketTable').on('load', loadWithVulnTable());
            break;
            case 'withoutVuln':
                    document.getElementById("withVuln").style.display = 'none';
            $('#withoutVulnTicketTable').on('load', loadWithoutVulnTable());
            break;
            }
            setTimeout(function () {
            $('#withVulnTicketTable').DataTable().columns.adjust().draw();
            $('#withoutVulnTicketTable').DataTable().columns.adjust().draw();
            }, 300);
            }

            function getTicketCounts() {
            var obj = getObjectByForm("searchForm");
            obj["newTickets"] = newTickets;
            $.ajax({
            "type": "POST",
                    "url": "loadTicketCounts.data",
                    "success": function (result) {
                    $("#tabWithoutVulnHeader").html('<spring:message code="listTickets.ticketsWithoutVuln"/>' + ' (' + result[0] + ')');
                    $("#tabWithVulnHeader").html('<spring:message code="listTickets.ticketsWithVuln"/>' + ' (' + result[1] + ')');
                    },
                    "data": obj,
                    "error": function (jqXHR, textStatus, errorThrown) {
                    console.log("Ajax error!" + textStatus + " " + errorThrown);
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                    $("#alertModal").modal("show");
                    }
            });
            }

            var oTable;
            var oTable2;
            function loadWithVulnTable() {
            oTable = $('#withVulnTicketTable').dataTable({
            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'B><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "serverSide": true,
                    "processing": true,
                    "bFilter": false,
                    "stateSave": true,
                    "scrollX": true,
                    "columnDefs": [
                    { className: 'noVis', targets: 8 },
                    { className: 'noVis', targets: 9 }
                    ],
                    "buttons": [
                    {
                    extend: 'colvis',
                            columns: ':not(.noVis)'
                    }
                    ],
                    "columns": [
                    {
                    "data": "ticketCustomerId"

                    },
                    {
                    "data": function (data, type, dataToSet) {
                    switch (data.ticketPriority.languageText.toString()) {
                    case "0" :
                            return '<div class="riskLevel0 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "1" :
                            return '<div class="riskLevel1 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "2" :
                            return '<div class="riskLevel2 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "3" :
                            return '<div class="riskLevel3 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "4" :
                            return '<div class="riskLevel4 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + ' </div>';
                    case "5" :
                            return '<div class="riskLevel5 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    }
                    return data.ticketPriority.languageText;
                    },
                            "orderable": true,
                            "orderData": [9]
                    },
                    {
                    "data": "svName",
                            "orderable": true
                    },
                    {
                    "data": "assetName",
                            "orderable": false
                    },
                    {
                    "data": function (data) {
                    return '<b>' + data.ticketStatus.languageText + '</b><br/>' + data.assigneeDatatableText;
                    },
                            "orderable": false
                    },
                    {
                    "data": function (data) {
                    return '<b>' + data.createDate + '</b><br/>' + data.createUserDatatableText;
                    },
                            "orderable": true,
                            "orderData": [10]
                    },
                    {
                    "data": function (data) {
                    if (data.closingDate === null) {
                    return '-';
                    } else {
                    return '<b>' + data.closingDate + '</b><br/>' + data.closeUserDatatableText;
                    }
                    },
                            "orderable": false
                    },
                    {
                    "data": function (data, type, dataToSet) {
                    return slaTimelineProjection(data);
                    },
                            "searchable": false,
                            "orderable": false,
                            "width": "12%"
                    },
                    {
                    "data": function (data, type, dataToSet) {
                    return returnWithVulnDataFunk();
                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {
                    "data": 'ticketPriority.languageText',
                            "visible": false
                    },
                    {
                    "data": 'createDate',
                            "visible": false
                    }
                    ],
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
                    "ajax": {
                    "type": "POST",
                            "url": "loadWithVulnTickets.data",
                            data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                            obj[key] = tempObj[key];
                            });
                            obj["newTickets"] = newTickets;
                            }
                    },
                    "oLanguage": {
                    "processing": decodeHtml("<spring:message code="generic.tableLoading"/>"),
                            "search": decodeHtml("<spring:message code="generic.search"/>"),
                            "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                            "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                            "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                            "paginate": {
                            "next": decodeHtml("<spring:message code="generic.next"/>"),
                                    "previous": decodeHtml("<spring:message code="generic.back"/>")
                            },
                            "sProcessing": "<spring:message code="generic.tableLoading"/>",
                            "sSearch": "<spring:message code="generic.search"/>",
                            "sInfo": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                            "sLengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                            "sEmptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                            "oPaginate": {
                            "next": decodeHtml("<spring:message code="generic.next"/>"),
                                    "previous": decodeHtml("<spring:message code="generic.back"/>"),
                                    "sNext": decodeHtml("<spring:message code="generic.next"/>"),
                                    "sPrevious": decodeHtml("<spring:message code="generic.back"/>")
                            }
                    },
                    "bPaginate": true,
                    "initComplete": function (settings, json) {
                    $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                    oTable.fnAdjustColumnSizing();
                    $("[data-toggle=popover]").popover({container: 'body'});
                    $('[data-toggle="tooltip"]').tooltip();
                    },
                    "fnDrawCallback": function (oSettings) {
                    getTicketCounts();
                    $("[data-toggle=popover]").popover({container: 'body'});
                    $('[data-toggle="tooltip"]').tooltip();
                    }
            });
            }
            function loadWithoutVulnTable() {
            oTable2 = $('#withoutVulnTicketTable').dataTable({
            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'B><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "serverSide": true,
                    "processing": true,
                    "bFilter": false,
                    "stateSave": true,
                    "scrollX": true,
                    "columnDefs": [
                    { className: 'noVis', targets: 8 },
                    { className: 'noVis', targets: 9 }
                    ],
                    "buttons": [
                    {
                    extend: 'colvis',
                            columns: ':not(.noVis)'
                    }
                    ],
                    "columns": [
                    {
                    "data": "ticketCustomerId"

                    },
                    {
                    "data": function (data, type, dataToSet) {
                    switch (data.ticketPriority.languageText.toString()) {
                    case "0" :
                            return '<div class="riskLevel0 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "1" :
                            return '<div class="riskLevel1 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "2" :
                            return '<div class="riskLevel2 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "3" :
                            return '<div class="riskLevel3 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "4" :
                            return '<div class="riskLevel4 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    case "5" :
                            return '<div class="riskLevel5 riskLevelCommon">' + data.ticketPriority.languageText + ' (' + data.ticketPriority.priorityDescription + ')' + '</div>';
                    }
                    return data.ticketPriority.languageText;
                    },
                            "orderable": true,
                            "orderData": [9]
                    },
                    {
                    "data": "svName"

                    },
                    {
                    "data": "assetName",
                            "orderable": false
                    }, {
                    "data": function (data) {
                    return '<b>' + data.ticketStatus.languageText + '</b><br/>' + data.assigneeDatatableText;
                    },
                            "orderable": false
                    },
                    {
                    "data": function (data) {
                    return '<b>' + data.createDate + '</b><br/>' + data.createUserDatatableText;
                    },
                            "orderable": true,
                            "orderData": [10]
                    },
                    {
                    "data": function (data) {
                    if (data.closingDate === null) {
                    return '-';
                    } else {
                    return '<b>' + data.closingDate + '</b><br/>' + data.closeUserDatatableText;
                    }
                    },
                            "orderable": false
                    },
                    {
                    "data": function (data, type, dataToSet) {
                    return slaTimelineProjection(data);
                    },
                            "searchable": false,
                            "orderable": false,
                            "width":"12%"
                    },
                    {
                    "data": function (data, type, dataToSet) {
                    return returnWithoutVulnDataFunk(data);
                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {
                    "data": 'ticketPriority.languageText',
                            "visible": false
                    },
                    {
                    "data": 'createDate',
                            "visible": false
                    }
                    ],
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
                    "ajax": {
                    "type": "POST",
                            "url": "loadWithoutVulnTickets.data",
                            data: function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                            obj[key] = tempObj[key];
                            });
                            obj["newTickets"] = newTickets;
                            }
                    },
                    "oLanguage": {
                    "processing": decodeHtml("<spring:message code="generic.tableLoading"/>"),
                            "search": decodeHtml("<spring:message code="generic.search"/>"),
                            "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                            "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                            "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                            "paginate": {
                            "next": decodeHtml("<spring:message code="generic.next"/>"),
                                    "previous": decodeHtml("<spring:message code="generic.back"/>")
                            },
                            "sProcessing": "<spring:message code="generic.tableLoading"/>",
                            "sSearch": "<spring:message code="generic.search"/>",
                            "sInfo": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                            "sLengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                            "sEmptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                            "oPaginate": {
                            "next": decodeHtml("<spring:message code="generic.next"/>"),
                                    "previous": decodeHtml("<spring:message code="generic.back"/>"),
                                    "sNext": decodeHtml("<spring:message code="generic.next"/>"),
                                    "sPrevious": decodeHtml("<spring:message code="generic.back"/>")
                            }
                    },
                    "bPaginate": true,
                    "initComplete": function (settings, json) {
                    $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                    oTable2.fnAdjustColumnSizing();
                    $("[data-toggle=popover]").popover();
                    $('[data-toggle="tooltip"]').tooltip();
                    },
                    "fnDrawCallback": function (oSettings) {
                    getTicketCounts();
                    $("[data-toggle=popover]").popover();
                    }
            });
            }

            function slaTimelineProjection(data) {
            if (data.slaPassed === "true") {
            if (data.statusId === "2") {
            var percentage = data.slaPercentage + 1;
            if (percentage > 87) {
            percentage = 87;
            }
            return ' <div class="row slaPresentation" style="margin-left: 0px;"> <div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#E10000;width:85%;height:25px;text-align:right;border-radius:3px">\n\
                                              <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                                    <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                                    <span class="glyphicon glyphicon-time" style="font-size:20px;margin-top:5px;margin-left:-6px;color:white;z-index:50000"></span></div>\n\
                                                </div>\n\
                                                <div style="height: 25px;margin-top:-31.5px;margin-right:-18px;font-size:31px;color:#E10000"><span style="" class="glyphicon glyphicon-pause"></span></div>\n\
                                        </div>    </div>';
            } else {
            var percentage = data.slaPercentage + 1;
            if (percentage > 87) {
            percentage = 87;
            }
            return ' <div class="row slaPresentation" style="margin-left: 0px;"> <div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#E10000;width:85%;height:25px;text-align:right;border-radius:3px">\n\
                                                <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                                    <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                                    <span class="glyphicon glyphicon-time" style="font-size:20px;margin-top:5px;margin-left:-6px;color:white;z-index:50000"></span></div>\n\
                                                </div>\n\
                                                <div style="height: 25px;margin-top:-27px;margin-right:-17px;font-size:25px;color:#E10000"><span style="" class="glyphicon glyphicon-triangle-right"></span></div>\n\
                                </div>          </div>';
            }

            } else if (data.slaPassed === "false") {
            if (data.statusId === "2") {
            var percentage = data.slaPercentage + 1;
            if (percentage > 87) {
            percentage = 87;
            }
            return '<div class="slaPresentation" data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#B0DAFF;width:100px;height:25px;text-align:right;border-radius:3px">\n\
                                                <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                                    <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                                    </div>\n\
                                                </div>\n\
                                                <div style="margin-top:-28px;margin-right:-12px;font-size:25px;color:#8eb1d0"><span class="glyphicon glyphicon-time"></span></div>\n\
                                            </div>';
            } else {
            var percentage = data.slaPercentage + 1;
            if (percentage > 81) {
            percentage = 81;
            }
            return '<div class="slaPresentation" data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#B0DAFF;width:100px;height:25px;text-align:right;border-radius:3px">\n\
                                                <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                                    <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                                    <span class="glyphicon glyphicon-triangle-right" style="font-size:25px;margin-top:5px;margin-left:-8px;color:#337AB7;"></span></div>\n\
                                                </div>\n\
                                                <div style="margin-top:-28px;margin-right:-12px;font-size:25px;color:#8eb1d0"><span class="glyphicon glyphicon-time"></span></div>\n\
                                            </div>';
            }
            } else if (data.slaPassed === "none-closed") {
            return '<div class="slaPresentation" data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="ticket.slaNotDefined"/>' + '&nbsp;' + data.difTimeString + '" style="background-color:#337AB7;width:95px;height:25px;border-radius:3px">\n\
                                            <span  style="float:right;margin-top:4px;margin-right:-18px;font-size:31px;color:#337AB7" class="glyphicon glyphicon-pause"></span></div>';
            } else if (data.slaPassed === "none-open") {
            return '<div class="slaPresentation" data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="ticket.slaNotDefined"/>' + '&nbsp;' + data.difTimeString + '" style="background-color:#E10000;width:100px;height:25px;border-radius:3px">\n\
                                            <span  style="float:right;margin-top:5px;margin-right:-17px;font-size:25px;color:#E10000" class="glyphicon glyphicon-triangle-right"></span></div>';
            }
            }

        </script>
    </jsp:attribute>  

    <jsp:body>
        <div class="row">
            <div class="col-lg-12">                   
                <!-- /.panel-heading -->
                <div class="portlet-body">
                    <div >
                        <div class="panel with-nav-tabs panel-default">
                            <div class="tabbable-custom nav justified">
                                <ul class="nav nav-tabs nav-justified">
                                    <li class="active" ><a onClick="updateCurrentTab('withVuln');"  style="text-decoration:none;color:#428bca" href="#tab1default" data-toggle="tab"><div id="tabWithVulnHeader"><spring:message code="listTickets.ticketsWithVuln"/></div></a></li>
                                    <li><a onClick="updateCurrentTab('withoutVuln');"  style="text-decoration:none;color:#428bca" href="#tab2default" data-toggle="tab"><div id="tabWithoutVulnHeader"><spring:message code="listTickets.ticketsWithoutVuln"/></div></a></li>
                                </ul>
                            </div>
                            <div class="panel-body">
                                <div class="tab-content">
                                    <div class="tab-pane fade in active" id="tab1default">
                                        <div>
                                            <table id="withVulnTicketTable" width="100%" class="table table-striped table-bordered table-hover" cellspacing="0" width="100%">
                                                <thead class="datatablesThead">
                                                    <tr>
                                                        <th><spring:message code="datatable.ticketCustomerId"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="datatable.ticketPriority.languageText"/></th>
                                                        <th><spring:message code="mailtemp.tName"/></th>
                                                        <th><spring:message code="datatable.assetName"/></th>                       
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="datatable.ticketStatus.languageText"/></th>        
                                                        <th><spring:message code="vulnerability.create"/></th>
                                                        <th><spring:message code="datatable.closingDate"/></th>
                                                        <th><spring:message code="datatable.difTimeString"/></th>
                                                        <th><div style='min-width: 103px;' style="height:10px"></div></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>                                                        
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="tab2default">
                                        <div>
                                            <table id="withoutVulnTicketTable" width="100%" class="table table-striped table-bordered table-hover" cellspacing="0" width="100%">
                                                <thead class="datatablesThead">
                                                    <tr>
                                                        <th><spring:message code="datatable.ticketCustomerId"/></th>
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="datatable.ticketPriority.languageText"/></th>
                                                        <th><spring:message code="mailtemp.tName"/></th>
                                                        <th><spring:message code="datatable.assetName"/></th>                       
                                                        <th style="vertical-align: middle; min-width: 80px;" width="80px"><spring:message code="datatable.ticketStatus.languageText"/></th>      
                                                        <th><spring:message code="vulnerability.create"/></th>
                                                        <th><spring:message code="datatable.closingDate"/></th>
                                                        <th><spring:message code="datatable.difTimeString"/></th>
                                                        <th><div style='min-width: 103px;' style="height:10px"></div></th>
                                                        <th style="display: none"></th>
                                                        <th style="display: none"></th>                                                        
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
        <jsp:include page="../../tool/jsInformationOkCancelModal.jsp" />
        <div class="modal fade" id="selectReportType" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width:25%">
                <div class="modal-content">
                    <div class="modal-header">
                        <spring:message code="listVulnerabilities.reportType"/>
                    </div>
                    <div class="modal-body">                      
                        <div class="panel-body">
                            <div class="form-group">
                                <label><spring:message code="listVulnerabilities.reportType"/></label>&nbsp;                                              
                                <select id="reportType" class="selectpicker btn btn-sm btn-default btn-info dropdown-toggle" onchange="reportTypeChanged();" data-style="btn btn-info btn-sm">
                                    <option value='<spring:message code="listVulnerabilities.pdf"/>'><spring:message code="listVulnerabilities.pdf"/></option>
                                </select>
                            </div>
                            <div class="form-group required">
                                <label><spring:message code="reviewReport.reportName"/></label>
                                <div style="display:flex;">
                                    <input class="form-control" id ="reportName" maxlength="50" style="width:80%;">
                                    <span id ="reportExtension" style="width:20%;line-height:3;margin-left:2px;"><b>.pdf</b></span>  
                                </div>
                            </div>
                            <div class="form-group">
                                <p id="reportErrorPTag" style="color:red;display:none;">
                                    <br><b><spring:message code="report.reportNameValidation"/></b></p>        
                            </div>
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
    </jsp:body>

</biznet:mainPanel>

