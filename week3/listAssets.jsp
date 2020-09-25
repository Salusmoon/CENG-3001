<%-- 
    Document   : listAssets
    Created on : Feb 24, 2015, 3:54:37 PM
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>

<c:set var="context" value="${pageContext.request.contextPath}" />
<link href="${context}/resources/css/listAssets.css" rel="stylesheet" type="text/css" />
<biznet:mainPanel viewParams="title,search,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listAssets.title"/></span>
            </li>
        </ul>

    </jsp:attribute>

    <jsp:attribute name="search">

        <biznet:searchpanel tableType="assetSearchDatatable" tableName="oTable">
            <jsp:body>
                <div class="col-lg-12" style="left:-1%;">

                    <div class="col-lg-3" >
                        <div class="col-lg-4">
                            <label class="control-label" id="labelAsset" ><b><spring:message code="listAssets.asset"/></b></label>
                        </div>
                        <div class="col-lg-8">
                            <input class="form-control" id="inputAsset" name="assetValue" placeholder=""> 
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <div class="col-lg-4">
                            <label class="control-label" id="betweenAssetLabel" style="display: none;" ><b><spring:message code="listAssets.ipFinish"/></b></label>
                        </div>
                        <div class="col-lg-8" id = "betweenAssetDiv" >
                            <input class="form-control" id="inputBetweenAsset" name="assetBetweenValue" placeholder="" style="display: none;">
                        </div> 

                        <!---->
                        <div class="col-lg-4">
                            <label id="exactMatchLabel"><b><spring:message code="listAssets.exactMatch"/></b></label> 
                        </div>
                        <div class="col-lg-8">
                            <input type="checkbox" id="exactMatch" name="exactMatch" style="position:relative;left:19px;">
                                <div class="bizzy-help-tip" id="helpTool">
                                    <i class="fas fa-info-circle" style="font-size: 15px; position:relative; bottom:7px;"></i>
                                    <p style="left:0px; right:0px;"><spring:message code="listAssets.exactMatchToolTip"/></p>
                                </div> 

                        </div>        
                    </div>    

                    <div class="col-lg-3">
                        <div class="col-lg-4">
                            <label ><b><spring:message code="listAssets.ipBetween"/></b></label> 
                        </div>
                        <div class="col-lg-8">
                            <input type="checkbox" id="showBetween"  style="position: relative;left:19px" name="showBetween" onclick="controlBetweenAsset();">
                                <div class="bizzy-help-tip" >
                                    <i class="fas fa-info-circle" style="font-size: 15px; position:relative; bottom:7px;"></i>
                                    <p style="left:0px; right:0px;"><spring:message code="listAssets.showBetweenToolTip"/></p>
                                </div> 
                        </div>
                        <div class="col-lg-8"   style="left:-30%;">

                        </div>

                    </div>
                    <div class="col-lg-3">
                        <div class="col-lg-4">
                            <label ><b><spring:message code="assetSearchPanel.assetStatus"/></b></label> 
                        </div>
                        <div class="col-lg-8">
                            <select id="assetStatus" name="assetStatus" class="js-example-basic-single js-states form-control" style="width: 100%;">
                                <option value="allAssets"><spring:message code="main.theme.listAllAssets"/></option>
                                <option value="onlyAllOpenAssets"><spring:message code="assetSearchPanel.onlyAllOpenAssets"/></option>
                                <option value="onlyAllClosedAssets"><spring:message code="assetSearchPanel.onlyAllClosedAssets"/></option>
                            </select>  
                        </div>
                        <div class="col-lg-8"   style="left:-30%;">
                        </div>
                    </div>

                </div>
                <div class="mt-4 col-md-12" style="height:5px;" >

                </div>

                <div class="col-lg-12" style="left:-1%;">

                    <div class="col-lg-3"  >
                        <div class="col-lg-4">
                            <label class="control-label"><b><spring:message code="listVulnerabilities.dateRange"/></b></label>
                        </div>
                        <div class="col-lg-8">
                            <div class='input-group date' id='dateTimeScan'>
                                <input name="daterange" class="form-control" id="daterange" readonly/>
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-calendar"></span>
                                </span>
                            </div> 
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <div class="col-lg-4">
                            <label class="control-label"><b><spring:message code="addAssetGroup.group"/></b></label>  
                        </div>
                        <div class="col-lg-8">
                              <select class="js-example-tags form-control" id ="assetGroups" name="assetGroups" path="asset.groups" style="width:100%;">                                                   
                              </select>
                        </div>
                    </div>      

                    <div class="col-lg-3">
                        <div class="col-lg-3">
                            <label class="control-label"><b><spring:message code="addAsset.hostname"/></b></label>

                        </div>
                        <div class="col-lg-1">
                            <input type="checkbox" id="hostNameChecked" name="hostNameChecked" >

                        </div>
                        <div class="col-lg-8">
                            <input class="form-control" id="hostName" name="hostName" placeholder="">  
                        </div>                               
                    </div>
                            
                    <div class="col-lg-3">
                        <div class="col-lg-4">
                            <label ><b><spring:message code="listAssets.passive"/></b></label> 
                        </div>
                        <div class="col-lg-8">
                            <select id="isPassive" name="state" class="js-example-basic-single js-states form-control" style="width: 100%;">
                                <option value="NULL"></option>
                                <option value="active"><spring:message code="dashboard.activeScansCount"/></option>
                                <option value="passive"><spring:message code="genericdb.passive"/></option>
                            </select>  
                        </div>
                        <div class="col-lg-8"   style="left:-30%;">

                        </div>

                    </div>

                </div> 

                <div class="mt-4 col-md-12" style="height:10px;">

                </div>
                <div class="col-lg-12" style="left:-1%;">

                    <div class="col-lg-3" >
                        <div class="col-lg-2">
                            <label class="control-label"><b><spring:message code="listAssets.port"/></b></label>
                        </div>
                        <div class="col-lg-2">
                            <input type="checkbox" title="And Seçimi" id="isAndSelected" name="portAndSelected" >&nbsp;
                                <span class="bizzy-help-tip" style="font-size:15px; top:1px !important;">
                                    <i class="fas fa-info-circle "></i>
                                    <p style="left:0px; right:0px;" ><spring:message code="listAssets.isAndSelectedToolTip"/></p>
                                </span>

                        </div>

                        <div class="col-lg-8">
                            <input class="form-control" id="portNumber" name="portNumber" placeholder="" >
                        </div>
                    </div>

                    <div class="col-lg-3" >
                        <div class="col-lg-4">
                            <label class="control-label"><b><spring:message code="listAssets.os"/></b></label>
                        </div>
                        <div class="col-lg-8">
                            <input class="form-control" id="osName" name="osName" placeholder="">  
                        </div>
                    </div>

                    <div class="col-lg-3" >
                        <div class="col-lg-4">
                            <label class="control-label"><b><spring:message code="listAssets.service"/></b></label>
                        </div>
                        <div class="col-lg-8">
                            <input class="form-control" id="serviceName" name="serviceName" placeholder="">  
                        </div>
                    </div>    
                    <div class="col-lg-3">
                        <div class="col-lg-4">
                            <label class="control-label" ><b><spring:message code="listAssets.assetProps"/></b></label>
                        </div>
                        <div class="col-lg-8" >
                            <select id ="assetProps" name="assetProps" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                <c:forEach items="${assetProps}" var="assetProp">
                                    <option value="<c:out value="${assetProp.parameter}"/>"><c:out value="${assetProp.parameter}"/></option>
                                </c:forEach>    
                            </select>
                        </div>
                    </div>
                </div> 
                <div class="mt-4 col-md-12" style="margin-bottom:10px;">

                </div>
            </jsp:body>
        </biznet:searchpanel>

    </jsp:attribute>

    <jsp:attribute name="alert">

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <spring:message code="${error}"></spring:message>
                </div>
        </c:if>
        <c:if test="${not empty addedAssetsCount}">
            <div class="alert alert-success">
                <c:out value="${addedAssetsCount}"/> <spring:message code="listAssets.success"/>
            </div>
        </c:if>
        <c:if test="${not empty alreadyAddedAssets}">
            <div class="alert alert-warning">
                <spring:message code="listAssets.alreadyAdded"/> <c:out value="${alreadyAddedAssets}"/>
            </div>
        </c:if>

    </jsp:attribute>


    <jsp:attribute name ="script">

        <script type="text/javascript">
            var assetExist = true;
            function validate(evt) {
            var theEvent = evt || window.event;
            // Handle paste
            if (theEvent.type === 'paste') {
            key = event.clipboardData.getData('text/plain');
            } else {
            // Handle key press
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode(key);
            }
            var regex = /[0-9]|\./;
            if (!regex.test(key)) {
            theEvent.returnValue = false;
            if (theEvent.preventDefault)
                    theEvent.preventDefault();
            }
            }
            document.title = '<spring:message code="generic.assets"/> - BIZZY';
            $('.dropdownToggle').on('click', function (){
            setTimeout(function(){
            $('#serverDatatables').DataTable().columns.adjust().draw();
            }, 300);
            });
            var url = window.location.href;
            var assetPageOpened = {};
            var a = 0;
            var newAssets;
            if ("${osValue}".length > 0) {
            $("#osName").val("${osValue}");
            $("#exactMatch").prop('checked', true);
            }
            if ("${serviceValue}".length > 0) {
            $("#serviceName").val("${serviceValue}");
            $("#exactMatch").prop('checked', true);
            }
            if ("${date}".length > 0) {
            newAssets = "${date}";
            }
            if (url.indexOf("groupId") > - 1 || url.indexOf("level") > - 1 || url.indexOf("osValue") > - 1 || url.indexOf("serviceValue") > - 1
                    || url.indexOf("new") > - 1 || url.indexOf("all") > - 1) {
            assetPageOpened = 1;
            } else {
            loadLocalStorage("listAssets");
            if (localStorage.getItem("listAssets") != null){
            var isRange = JSON.parse(localStorage.getItem("listAssets")).inputBetweenAsset;
            if (isRange !== ""){
            $("#showBetween").prop('checked', true);
            $("#exactMatch").prop('checked', false);
            $("#exactMatchLabel").hide();
            $("#helpTool").hide();
            $("#exactMatch").hide();
            $("#inputBetweenAsset").show();
            $("#betweenAssetLabel").show();
            $("#labelAsset").text(decodeHtml("<spring:message code="listAssets.ipStart"/>"));
            $("#labelAsset").css("font-weight", "bold");
            }
            var isExact = JSON.parse(localStorage.getItem("listAssets")).exactMatch;
            if (isExact === "on"){
            $("#exactMatch").prop('checked', true);
            }
            }
            }
            var currentAssetId = "";
            var riskScoreCursorChart, riskScoreCursorAxis2, riskScoreCursorRange0, riskScoreCursorRange1, riskScoreCursorLabel, riskScoreCursorHand;
            var labelsAndColors = [];
            var labelsList = [];
            var assetColors = [];
            var assetPropsAndColors = [];
            var assetPropsList = [];
            var propColors = [];
            <c:forEach var="item" items="${groups}">
            assetColors.push("default");
            assetColors.push("info");
            assetColors.push("success");
            assetColors.push("warning");
            assetColors.push("primary");
            assetColors.push("danger");
            </c:forEach>
            <c:forEach var="item" items="${assetProps}">
            propColors.push("default");
            propColors.push("info");
            propColors.push("success");
            propColors.push("warning");
            propColors.push("primary");
            propColors.push("danger");
            </c:forEach>
            <c:forEach var="item" items="${groups}" varStatus="loop">
            labelsAndColors.push('<a href = "javascript:;" data-trigger="focus" data-toggle="popover" data-placement="top"  data-content="' + "<spring:message code="listAssets.groupTree"/>" + '" style="text-decoration:none; color : black;display:inline-block;margin:1px;padding-top:3px;"><span class="label label-' + assetColors.pop() + '">' + '<c:out value="${item.name}"/>' + '</span></a>' + '&nbsp');
            labelsList.push('<c:out value="${item.name}"/>');
            </c:forEach>
            <c:forEach var="item" items="${assetProps}">
            assetPropsAndColors.push('<span class="label label-' + propColors.pop() + '">' + '<c:out value="${item.parameter}"/>' + '</span>' + '&nbsp');
            assetPropsList.push('<c:out value="${item.parameter}"/>');
            </c:forEach>
            var oTable;
            $(document).ready(function () {
            $(function () {
            $('#daterange').daterangepicker({
            autoUpdateInput: false,
                    locale: <c:choose>
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
            });
            $('[data-toggle="tooltip"]').tooltip();
            $('[data-toggle="popover"]').popover({html: true});
            
            blockUILoading();
            oTable = $('#serverDatatables').dataTable({
            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "serverSide": true,
                    "bFilter" : false,
                    "scrollX": true,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', width: 10, targets: 0 },
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN')">
                        { className: 'noVis', width: "3%", targets: 11 },
                        { className: 'noVis', width: "3%", targets: 12 }
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY') and !hasRole('ROLE_COMPANY_MANAGER')">
                        { className: 'noVis', width: "3%", targets: 10 },
                        { className: 'noVis', width: "3%", targets: 11 }
            </sec:authorize>                        
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "language": {
                    "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
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
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN')">
                    {
                    data: "assetId",
                            render: function (data, type, row) {
                            if (type === 'display') {
                            return '<input type="checkbox" class="editor-active" id="checkAsset" value="' + data + '" >';
                            }
                            return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                    },
            </sec:authorize>
                    {"data": function (data, type, dataToSet) {
                        if(data.assetType === 'VIRTUAL_HOST' && data.otherIps !== null && data.otherIps.length > 0) {
                            return data.otherIps[0];
                        } else {
                            return data.ip;
                        }
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN')">
                    }, "orderData": [12]},
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY') and !hasRole('ROLE_COMPANY_MANAGER')">
                    }, "orderData": [11]},
            </sec:authorize>
                    {"data": function (data, type, dataToSet) {
                        if(data.assetType === 'VIRTUAL_HOST' && data.otherIps !== null && data.otherIps.length > 0) {
                            return data.ip;
                        } else {
                            return data.hostname;
                        }
                    }, "searchable": false,
                            "orderable": false},
                    {"data": function (data, type, dataToSet){
                    var interval = ${topScore} / 5;
                    var ipRepDetected = "";
                    if (data.ipReputationDetected){
                    ipRepDetected = "<i class='fas fa-exclamation-circle'></i>";
                    }
                    if (interval === 0) {
                    interval = 1;
                    }
                    if (data.score >= interval * 4){
                    return '<div class="riskScore riskLevel5"><b>' + data.score + '</b><b style="float:right;font-size:25px;margin-top:-7px;data-toggle="tooltip" data-placement ="top" title ="IP Reputation">' + ipRepDetected + '&nbsp;</b></div>' }
                    if (data.score >= interval * 3){
                    return '<div class="riskScore riskLevel4"><b>' + data.score + '</b><b style="float:right;font-size:25px;margin-top:-7px;data-toggle="tooltip" data-placement ="top" title ="IP Reputation">' + ipRepDetected + '&nbsp;</b></div>' }
                    if (data.score >= interval * 2){
                    return '<div class="riskScore riskLevel3"><b>' + data.score + '</b><b style="float:right;font-size:25px;margin-top:-7px;data-toggle="tooltip" data-placement ="top" title ="IP Reputation">' + ipRepDetected + '&nbsp;</b></div>' }
                    if (data.score >= interval * 1){
                    return '<div class="riskScore riskLevel2"><b>' + data.score + '</b><b style="float:right;font-size:25px;margin-top:-7px;data-toggle="tooltip" data-placement ="top" title ="IP Reputation">' + ipRepDetected + '&nbsp;</b></div>' }
                    if (data.score > - 1){
                    return '<div class="riskScore riskLevel1"><b>' + data.score + '</b><b style="float:right;font-size:25px;margin-top:-7px;data-toggle="tooltip" data-placement ="top" title ="IP Reputation">' + ipRepDetected + '&nbsp;</b></div>' }

                    }
                    },
                    {"data": function (data, type, dataToSet) {
                    var html = "";
                    var sendGroup = [];
                    var sendGroupResult = [];
                    var groupTree = "";
                    var groups = data.groups;
                    var groupsLength = data.groups.length;
                    var groupsLengthCount = 0;
                    for (var i = 0; i < groupsLength; i++) {
                    sendGroup = [];
                    groupTree = "";
                    if (groups[i].groupId !== "deleted"){
                    if (groups[i].parentGroupId !== null){
                    sendGroup.push(decodeHtml(groups[i].name));
                    var m = i;
                    while (groups[m].parentGroupId !== null){
                    sendGroup.push(decodeHtml(groups[m + 1].name));
                    groups[m + 1].groupId = "deleted"; //tabloda gösterilmeyecek grubun anlaşılması için
                    m++;
                    }
                    }
                    for (var j = 0; j < labelsList.length; j++) {
                    if (decodeHtml(groups[i].name) === decodeHtml(labelsList[j])) {
                    groupsLengthCount++;
                    if (groups[i].parentGroupId !== null){
                    sendGroupResult = [];
                    var count = sendGroup.length - 1;
                    for (var l = 0; l < sendGroup.length; l++){
                    sendGroupResult[l] = sendGroup[count];
                    count--;
                    }
                    var k = 0;
                    for (; k < sendGroupResult.length - 1; k++){
                    groupTree += sendGroupResult[k] + " ➤ ";
                    }
                    groupTree += sendGroupResult[k];
                    labelsAndColors[j] = labelsAndColors[j].replace('<spring:message code="listAssets.groupTree"/>', groupTree);
                    }
                    if (groupsLengthCount % 3 == 0)
                            html += labelsAndColors[j] + '<br><br>';
                    else
                            html += labelsAndColors[j];
                    break;
                    }
                    }
                    }
                    }
                    groupsLengthCount = 0;
                    return '<div style="line-height:1.8;">'+html+'</div>';
                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {"data": function (data, type, dataToSet) {
                    return '<div style="text-align: center;">' + getOSLogo(data.operatingSystem, '${pageContext.request.contextPath}') + getAssetRoleLogo(data.assetRoles, '${pageContext.request.contextPath}') + '<div style="clear: left;"></div></div>';
                    }, "searchable": false,
                            "orderable": false
                    },
                    {"data": function (data, type, dataToSet) {
                    if (data.passiveVulnerabilityParameters !== null || data.passiveVulnerabilityParameters.length !== 0) {
                    var assetProp = "";
                    for (var i = 0; i < data.passiveVulnerabilityParameters.length; i++) {
                    for (var j = 0; j < assetPropsList.length; j++) {
                    var value = "'>" + data.passiveVulnerabilityParameters[i].parameter + "<'";
                    if (decodeHtml(data.passiveVulnerabilityParameters[i].parameter) === decodeHtml(assetPropsList[j]) && value.indexOf() === - 1) {
                    if (i % 2 == 0)
                            assetProp += assetPropsAndColors[j];
                    else
                            assetProp += assetPropsAndColors[j] + '<br><br>';
                    break;
                    }
                    }
                    }
                    if (assetProp === "" || assetProp.length === 0) {
                    return '<div style="padding-top:3px;" ><i class="fas fa-minus"></i> </div>';
                    } else {
                    return '<div  style="padding-top:3px;">' + assetProp + ' </div>';
                    }
                    } else {
                    return '<div  style="padding-top:3px;"><i class="fas fa-minus"></i> </div>';
                    }
                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {"data": function (data, type, dataToSet) {
                    var temp = data.vulnerabilityCount - data.closedVulnerabilityCount + " / " + data.closedVulnerabilityCount;
                    return temp;
                    }, "searchable": false, "orderable": false},
                    {"data": function (data, type, dataToSet) {
                    return progressDivHtml(data);
                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {"data": 'createDate'},
                    {"data": function (data, type, dataToSet) {
                    if (data.active === true){
                    return "<span style='color:black;' class='label label-default' data-toggle='tooltip' data-placement ='top' title ='<spring:message code="startScan.active"/>'><i class='fas fa-arrow-circle-up'  style='font-size:17px;color:green;margin-top:5px'></i> " + data.activeOrPassiveSince + "</span>";
                    }
                    else {
                    return "<span style='color:black;' class='label label-default' data-toggle='tooltip' data-placement ='top' title ='<spring:message code="genericdb.passive"/>'><i class='fas fa-arrow-circle-down'  style='font-size:17px;color:red;margin-top:5px'></i> " + data.activeOrPassiveSince + "</span>";
                    }

                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {
                    "data": function (data, type, dataToSet) {
                    var html = '<div class="dropdown"><button class="btn btn-sm dropdown-toggle dropdownToggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                    html += '<li style="list-style: none;"><a  onclick="showModal(\'' + data.assetId + '\',' + ${topScore} + ')" data-placement="top"><spring:message code="generic.detail"/></a></li>  ';
                    if (data.vulnerabilityCount > 0){
                    html += '<li style="list-style: none;"><a  onclick="openReportTypeModal(\'' + data.assetId + '\')" data-placement="top"><spring:message code="listScans.report"/></a></li>  ';
                    }
                    html += '<li style="list-style: none;"><a  href="listVirtualHosts.htm?assetId=' + data.assetId + '&assetIp='+data.ip+'" data-placement="top"><spring:message code="generic.hosts"/></a></li>  ';
                    html += '<li style="list-style: none;"><a  href="listPorts.htm?assetId=' + data.assetId +'&assetIp='+data.ip+'" data-placement="top"><spring:message code="generic.ports"/></a></li>  ';
                    if (data.vulnerabilityCount > 0){
                    html += '<li style="list-style: none;"><a  href="listVulnerabilities.htm?assetId=' + data.assetId + '" data-placement="top"><spring:message code="generic.vulnerabilities"/></a></li>  ';
                    }
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_REPORTER,ROLE_PENTEST_ADMIN')">
                <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                    html += '<li style="list-style: none;"><a  onclick="openCopyModal(\'' + data.assetId + '\')" data-placement="top"><spring:message code="listAssets.copyAsset"/></a></li>  ';
                    html += '<li style="list-style: none;"><a  href="addAsset.htm?action=update&assetId=' + data.assetId + '" data-placement="top"><spring:message code="generic.edit"/></a></li>  ';
                </sec:authorize>
            </sec:authorize>
                    html += '</ul></div>';
                    return html;
                    },
                            "searchable": false,
                            "orderable": false
                    },
                    {"data": 'ip',
                        "visible": false
                    }
                    ],
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN')">
                    "order": [3, 'desc'],
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY') and !hasRole('ROLE_COMPANY_MANAGER')">
                    "order": [2, 'desc'],
            </sec:authorize>                    

                    "ajax": {
                    "type": "POST",
                            "url": "loadAssets.json",
                            "data": function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                            obj[key] = tempObj[key];
                            });
                            obj["newAssets"] = newAssets;
                            obj["customerId"] = "${custom:escapeForJavascript(customerId)}";
                            obj["groupId"] = "${custom:escapeForJavascript(groupId)}";
                            obj["level"] = "${custom:escapeForJavascript(level)}";
                            obj["maxVulnCount"] = ${maxVulnCount};
                            },
                            // error callback to handle error
                            "error": function (jqXHR, textStatus, errorThrown) {
                            if (jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                            } else {
                            ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>")
                            }
                            },
                            "complete": function () {
                                $('[data-toggle="popover"]').popover();
                                if (assetPageOpened !== 1) {
                                    localStorage.setItem("listAssets", JSON.stringify(getLocalStorageObjectWithArrayByForm("searchForm")));
                                }
                                unBlockUILoading();
                            }
                    },
                    "initComplete": function(settings, json) {
                    $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                    if (json.data.length !== 0){
                    var topScore = ${topScore};
                    if (topScore !== 0) {
                    am4core.useTheme(am4themes_animated);
                    riskScoreCursorChart = am4core.create("riskScoreCursor", am4charts.GaugeChart);
                    riskScoreCursorChart.hiddenState.properties.opacity = 0;
                    riskScoreCursorChart.fontSize = 11;
                    riskScoreCursorChart.innerRadius = am4core.percent(80);
                    riskScoreCursorChart.resizable = true;
                    /**
                     * Axis for ranges
                     */

                    var chartMin = 0;
                    var chartMax = topScore;
                    var interval = topScore / 3;
                    if (interval === 0) {
                    interval = 1;
                    }

                    var data = {
                    score: 1,
                            gradingData: [
                            {
                            title:"<spring:message code="assetsDetails.riskScore.low"/>",
                                    color: "#0f9747",
                                    lowScore: 0,
                                    highScore: interval * 1,
                            },
                            {
                            title: "<spring:message code="assetsDetails.riskScore.medium"/>",
                                    color: "#f3eb0c",
                                    lowScore: interval * 1,
                                    highScore: interval * 2
                            },
                            {
                            title: "<spring:message code="assetsDetails.riskScore.high"/>",
                                    color: "#ee1f25",
                                    lowScore: interval * 2,
                                    highScore: interval * 3
                            }

                            ]
                    };
                    function lookUpGrade(lookupScore, grades) {
                    for (var i = 0; i < grades.length; i++) {
                    if (
                            grades[i].lowScore < lookupScore &&
                            grades[i].highScore >= lookupScore
                            ) {
                    return grades[i];
                    }
                    }

                    return null;
                    }

                    colorSet = new am4core.ColorSet();
                    riskScoreCursorAxis1 = riskScoreCursorChart.xAxes.push(new am4charts.ValueAxis());
                    riskScoreCursorAxis1.min = chartMin;
                    riskScoreCursorAxis1.max = chartMax;
                    riskScoreCursorAxis1.renderer.innerRadius = 10;
                    riskScoreCursorAxis1.strictMinMax = true;
                    riskScoreCursorAxis1.renderer.grid.template.disabled = true;
                    riskScoreCursorAxis1.renderer.ticks.template.disabled = true;
                    riskScoreCursorAxis1.renderer.labels.template.disabled = true;
                    riskScoreCursorAxis2 = riskScoreCursorChart.xAxes.push(new am4charts.ValueAxis());
                    riskScoreCursorAxis2.min = chartMin;
                    riskScoreCursorAxis2.max = chartMax;
                    riskScoreCursorAxis2.strictMinMax = true;
                    riskScoreCursorAxis2.renderer.labels.template.disabled = true;
                    riskScoreCursorAxis2.renderer.ticks.template.disabled = true;
                    riskScoreCursorAxis2.renderer.grid.template.disabled = false;
                    riskScoreCursorAxis2.renderer.grid.template.opacity = 0.5;
                    riskScoreCursorAxis2.renderer.labels.template.bent = true;
                    riskScoreCursorAxis2.renderer.labels.template.fill = am4core.color("#000");
                    riskScoreCursorAxis2.renderer.labels.template.fontWeight = "bold";
                    riskScoreCursorAxis2.renderer.labels.template.fillOpacity = 0.3;
                    
                    
                    
                    for (var a = 0; a < data.gradingData.length; a++) {
                    riskScoreCursorRange0 = riskScoreCursorAxis2.axisRanges.create();
                    riskScoreCursorRange0.axisFill.fill = am4core.color(data.gradingData[a].color);
                    riskScoreCursorRange0.axisFill.fillOpacity = 1;
                    riskScoreCursorRange0.axisFill.zIndex = - 1;
                    riskScoreCursorRange0.value = data.gradingData[a].lowScore > chartMin ? data.gradingData[a].lowScore : chartMin;
                    riskScoreCursorRange0.endValue = data.gradingData[a].highScore < chartMax ? data.gradingData[a].highScore : chartMax;
                    riskScoreCursorRange0.grid.strokeOpacity = 0;
                    riskScoreCursorRange0.stroke = am4core.color(data.gradingData[a].color).lighten( - 0.1);
                    riskScoreCursorRange0.label.text = data.gradingData[a].title.toUpperCase();
                    riskScoreCursorRange0.label.inside = true;
                    riskScoreCursorRange0.label.inside = true;
                    riskScoreCursorRange0.label.location = 0.5;
                    riskScoreCursorRange0.label.inside = true;
                    riskScoreCursorRange0.label.radius = am4core.percent(5);
                    riskScoreCursorRange0.label.paddingBottom = - 5; // ~half font size
                    riskScoreCursorRange0.label.fontSize = "1.2em";
                    riskScoreCursorRange1 = riskScoreCursorAxis2.axisRanges.create();
                    }

                    var matchingGrade = lookUpGrade(data.score, data.gradingData);
                    riskScoreCursorLabel = riskScoreCursorChart.radarContainer.createChild(am4core.Label);
                    riskScoreCursorLabel.isMeasured = false;
                    riskScoreCursorLabel.fontSize = "3em";                    
                    riskScoreCursorLabel.horizontalCenter = "middle";
                    riskScoreCursorLabel.verticalCenter = "bottom";
                    riskScoreCursorLabel.fill = am4core.color(matchingGrade.color);
                    riskScoreCursorHand = riskScoreCursorChart.hands.push(new am4charts.ClockHand());
                    riskScoreCursorHand.axis = riskScoreCursorAxis2;
                    riskScoreCursorHand.innerRadius = am4core.percent(55);
                    riskScoreCursorHand.startWidth = 8;
                    riskScoreCursorHand.pin.disabled = true;
                    riskScoreCursorHand.value = data.score;
                    riskScoreCursorHand.fill = am4core.color("#444");
                    riskScoreCursorHand.stroke = am4core.color("#000");
                    }
                    }
                    $('[data-toggle="tooltip"]').tooltip();
                    $('[data-toggle="popover"]').popover();
                    },
                    "fnDrawCallback": function (oSettings) {
                    $('[data-toggle="tooltip"]').tooltip();
                    $('[data-toggle="popover"]').popover();
                    }

            });
            $('.dataTables_filter input')
                    .unbind()
                    .bind('keypress keyup', function (e) {
                    var length = $(this).val().length;
                    var keyCode = e.keyCode;
                    if (length >= 3 && keyCode === 13) {
                    oTable.fnFilter($(this).val());
                    } else if (length === 0) {
                    oTable.fnFilter("");
                    }
                    }).attr("placeholder", "<spring:message code="listAssets.searchTip" htmlEscape="false"/>").width('300px');
            var placeholder = decodeHtml("<spring:message code="listAssets.selectGroup"/>");
            $(".js-example-basic-multiple").select2({
            // placeholder:placeholder
            });
            });
            
            function deleteAssets() {

            function confirmDelete(){
            $(".page-wrapper").block({message: null});
            App.startPageLoading({animate: true});
            var assetIds = new Array();
            $('[id=checkAsset]:checked').each(function () {
            var tr = $(this).closest('tr');
            var row = oTable.api().row(tr);
            assetIds.push($(this).val());
            });
            var obj = getObjectByForm("searchForm");
            obj["assetIds"] = assetIds;
            obj["allRecords"] = $('#checkBoxAllRecords').is(":checked");
            obj["softOrHard"] = $("#softDelete").prop("checked");
            obj["customerId"] = "${custom:escapeForJavascript(customerId)}";
            obj["groupId"] = "${custom:escapeForJavascript(groupId)}";
            obj["newAssets"] = newAssets;
            $.post("deleteAsset.json", obj, function () {
            }).done(function(data, textStatus, jqXHR) {
            if (data.activeScan !== undefined){
            //Aktif tarama olduğundan silme işlemi yapılmadı.
            $("#alertModalBody").empty();
            $("#alertModalBody").html(data.activeScan + " <spring:message code="listAssets.deleteRejected"/>");
            $("#alertModal").modal("show");
            } else{
            oTable.api().draw();
            }
            }).fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status === 403) {
            window.location = '../error/userForbidden.htm';
            } else {
            $("#alertModalBody").empty();
            $("#alertModalBody").html("<spring:message code="listAssets.deleteFail"/>");
            $("#alertModal").modal("show");
            }
            }).always(function () {
            $(".page-wrapper").unblock({message: null});
            App.stopPageLoading();
            });
            }
            var deleteDivText = '<input type="radio" id="softDelete" name="softOrHard" value="softDelete" checked>' + "<spring:message code="listAssets.softDeleteAsset"/>" + '<br><br><input type="radio" id="hardDelete" name="softOrHard" value="hardDelete">' + "<spring:message code="listAssets.hardDeleteAsset"/>" + '<br>';
            jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listAssets.confirmDelete"/>"), confirmDelete);
            $("#informationOkCancelP").html(deleteDivText);
            }
            function progressDivHtml(data) {
            var html = '';
            var riskMap = new Object();
            var riskMap2=new Object();
            var riskSize = new Object();
            var tempRiskSize = new Object();
            riskMap = data.riskDistribution;
            riskMap2 = Object.assign({},data.riskDistribution);
            
            var assetId = data.assetId;
            var maxVuln = data.maxVulnCount;
            var riskSizeAll = 0;
            for (var i = 0; i < 7; i++) {
            if (typeof riskMap[i] === 'undefined') {
            riskMap[i] = 0;
            riskMap2[i] = 0;
            }
            riskSizeAll += riskMap[i];
            }
            riskMap[6] = maxVuln - riskSizeAll;
            riskMap2[6] = maxVuln - riskSizeAll;
            riskSizeAll = maxVuln;
            // en küçük aralıklı risk değerinin 10% oranında görüntülenmesi sağlandı.
            var riskSizeForLarges = 0;
            var perCentSize = 100;
            /*for (var i = 0; i < 6; i++) {
             if (riskMap[i] !== 0 && (riskMap[i] / riskSizeAll < 0.1)) {
             riskSize[i] = 10;
             perCentSize -= 10;
             } else {
             riskSize[i] = 0;
             riskSizeForLarges += riskMap[i];
             }
             }
             riskSizeForLarges += riskMap[6];*/

            //en küçük değerlerden arta kalan kısma büyük değerlerin paylaştırılması sağlandı.
            /*for (var i = 0; i < 6; i++) {
             if (riskMap[i] !== 0 && !(riskMap[i] / riskSizeAll < 0.1)) {
             riskSize[i] = (riskMap[i] / riskSizeForLarges)*perCentSize;
             }
             }
             if(riskMap[6] !== 0) {
             riskSize[6] = (riskMap[6] / riskSizeForLarges)*perCentSize;
             }*/
            
            for (var i = 0; i < 7; i++) {
            if (riskMap[i] !== 0) {
            riskSize[i] = (riskMap[i] / riskSizeAll) * perCentSize;
            if (riskSize[i] < 9) {
            riskMap[i] = '';
            }
            } else {
            riskSize[i] = 0;
            }
            }
            var titleBar="<spring:message code="dashboard.level5"/>:" + " " + riskMap2[5]+"\n";
            titleBar+="<spring:message code="dashboard.level4"/>:" + " " + riskMap2[4]+"\n";
            titleBar+="<spring:message code="dashboard.level3"/>:" + " " + riskMap2[3]+"\n";
            titleBar+="<spring:message code="dashboard.level2"/>:" + " " + riskMap2[2]+"\n";
            titleBar+="<spring:message code="dashboard.level1"/>:" + " " + riskMap2[1]+"\n";
            // *** resources/assets/global/components.min.css dosyasından "Rounded corners reset" alanı kaldırıldı.
            // *** Metronic güncellemesi sonrası tekrar düzenlenmesi gerekiyor.
            html = '<div id=\"riskDistribution' + assetId + '\" class=\"riskDistribution' + assetId + '\" data-toggle=\"tooltip\" title=\"'+titleBar+'\"></div>'
                    + ' <script type=\'text/javascript\'>'
                    + ' $(\'.riskDistribution' + assetId + '\').multiprogressbar({'
                    + ' parts: ['
                    + '{value: ' + riskSize['5'] + ', text: "' + riskMap['5'] + '", barClass: "riskLevel5"},'
                    + '{value: ' + riskSize['4'] + ', text: "' + riskMap['4'] + '", barClass: "riskLevel4"},'
                    + '{value: ' + riskSize['3'] + ', text: "' + riskMap['3'] + '", barClass: "riskLevel3"},'
                    + '{value: ' + riskSize['2'] + ', text: "' + riskMap['2'] + '", barClass: "riskLevel2"},'
                    + '{value: ' + riskSize['1'] + ', text: "' + riskMap['1'] + '", barClass: "riskLevel1"},'
                    + '{value: ' + riskSize['0'] + ', text: "' + riskMap['0'] + '", barClass: "riskLevel0"},'
                    + '{value: ' + riskSize['6'] + ', text: "", barClass: "riskLevelNon"}'
                    + ' ]}); '
                    + '<\/script>';
            return html;
            }
          
            function clearAssetWithNoVuln(){
                   blockUILoading();
                

            function confirmDelete(){
            $(".page-wrapper").block({message: null});
            App.startPageLoading({animate: true});
            var assetIds = [];
            $('[id=checkAsset]:checked').each(function () {
            assetIds.push($(this).val());
            });
            var obj = getObjectByForm("searchForm");
            obj["assetIds"] = assetIds;
            obj["allRecords"] = $('#checkBoxAllRecords').is(":checked");
            obj["customerId"] = "${custom:escapeForJavascript(customerId)}";
            obj["groupId"] = "${custom:escapeForJavascript(groupId)}";
            obj["newAssets"] = newAssets;
            $.post("clearAssetsWithNoVulnerability.json", obj, function () {
            }).done(function(data, textStatus, jqXHR) {
            oTable.api().draw();
            }).fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status === 403) {
            window.location = '../error/userForbidden.htm';
            } else {
            $("#alertModalBody").empty();
            $("#alertModalBody").html("<spring:message code="listAssets.deleteFail"/>");
            $("#alertModal").modal("show");
            }
            }).always(function () {
            $(".page-wrapper").unblock({message: null});
            App.stopPageLoading();
            });
            }
            jsInformationOkCancelModalFunction("<spring:message code="listAssets.deleteAssetsWarning"/>", confirmDelete);
             unBlockUILoading();
            }

            function assetActions(option) {
            switch (option) {
            case "importAssetFromFile.htm":
                    window.location = "../customer/importAssetFromFile.htm";
            break;
            case "redirectReport":
                    $('#assetReport').modal('show');
            break;
            case "addPort" :
                    $("#multiAssetAddPortModal").modal('show');
            break;
            case "updateAsset":
                    $('#multiAssetParametersChangeModal').modal();
            break;
            }
            }


            function blockUILoading(){
            App.startPageLoading({animate: true});
            App.blockUI({ message: '<h1> </h1>' });
            }
            function unBlockUILoading(){
            App.stopPageLoading();
            App.unblockUI();
            }



            function controlBetweenAsset() {
            if ($('#showBetween').is(":checked")) {
            $("#betweenAssetLabel").show();
            $("#inputBetweenAsset").show();
            $("#exactMatchLabel").hide();
            $("#helpTool").hide();
            $("#exactMatch").prop('checked', false);
            $("#exactMatch").hide();
            $("#labelAsset").text(decodeHtml("<spring:message code="listAssets.ipStart"/>"));
            $("#labelAsset").css("font-weight", "bold");
            //  $("#labelAsset").innerHTML("<b><spring:message code="listAssets.ipStart"/></b>");
            } else {
            $("#betweenAssetLabel").hide();
            $("#inputBetweenAsset").hide();
            $("#exactMatchLabel").show();
            $("#helpTool").show();
            $("#exactMatch").show();
            $("#labelAsset").text("<spring:message code="listAssets.asset"/>");
            $("#labelAsset").css("font-weight", "bold");
            $("#inputBetweenAsset").val('');
            }
            }

            function assetReportNameControl(){
            var text = document.getElementById("assetReportName");
            if (!text.value || text.value.length === 0) {
            document.getElementById("statusErrorATag").style.visibility = "visible";
            //return 'fail';
            } else {
            document.getElementById("statusErrorATag").style.visibility = "hidden";
            redirectAssetsReport();
            // return 'success';
            }
            }
            //Varlık listesini Csv dosyasına raporlar.
            function redirectAssetsReport() {
            var params = getObjectByForm("searchForm");
            params["reportName"] = $('#assetReportName').val();
            params["customerId"] = "${custom:escapeForJavascript(customerId)}";
            params["groupId"] = "${custom:escapeForJavascript(groupId)}";
            params["newAssets"] = newAssets;
            generateReport("getAssetReport.json", params, "<spring:message code="report.reportCreation"/>",
                    "<spring:message code="listVulnerabilities.reportError"/>");
            closeAssetReportModal();
            }
            function closeAssetReportModal(){
            $('#assetReportName').val("");
            $('#assetReport').modal('hide');
            }

            var selectedAsset = {};
            function reportNameControl(){
            var text = document.getElementById("reportName");
            if (!text.value || text.value.length === 0) {
            document.getElementById("statusErrorPTag").style.visibility = "visible";
            //return 'fail';
            } else {
            document.getElementById("statusErrorPTag").style.visibility = "hidden";
            redirectAssetVulnsReport();
            // return 'success';
            }
            }
            
            function riskLevelFunc(){
            var parameters = {'assetId': selectedAsset,'reportType': $('#reportType').val(),'reportName': $('#reportName').val(),'statusGraphData': "",'riskLevelGraphData': "",'assetLevelGraphData': "",
            ${_csrf.parameterName}: "${_csrf.token}"
            };
            $.ajax({
            "type": "POST",
                    "url": "loadVulnerabilityRiskLevelGraph.json",
                    "success": function (result) {
                    var temp = result;
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
                    "data": parameters,
                    "error": function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                    } else {
                    console.log("Ajax error!" + textStatus + " " + errorThrown);
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                    $("#alertModal").modal("show");
                    }
                    }
            });
            }
            function statusFunc(){
            var parameters = {'assetId': selectedAsset,'reportType': $('#reportType').val(),'reportName': $('#reportName').val(),'statusGraphData': "",'riskLevelGraphData': "",'assetLevelGraphData': "",
            ${_csrf.parameterName}: "${_csrf.token}"
            };
            $.ajax({
            "type": "POST",
                    "url": "loadVulnerabilityStatusGraph.json",
                    "success": function (result) {
                    var temp = result;
                    var combined = [];
                    combined[0] = {"status": decodeHtml("<spring:message code="genericdb.OPEN"/>"), "color": '#67B7DC', "value": temp[0]};
                    combined[1] = {"status": decodeHtml("<spring:message code="genericdb.CLOSED"/>"), "color": '#FDD400', "value": temp[1]};
                    combined[2] = {"status": decodeHtml("<spring:message code="genericdb.RISK_ACCEPTED"/>"), "color": '#84B761', "value": temp[2]};
                    combined[3] = {"status": decodeHtml("<spring:message code="genericdb.RECHECK"/>"), "color": '#CC4748', "value": temp[3]};
                    combined[4] = {"status": decodeHtml("<spring:message code="genericdb.ON_HOLD"/>"), "color": '#CD82AD', "value": temp[4]};
                    combined[5] = {"status": decodeHtml("<spring:message code="genericdb.IN_PROGRESS"/>"), "color": '#2F4074', "value": temp[5]};
                    combined[6] = {"status": decodeHtml("<spring:message code="genericdb.FALSE_POSITIVE"/>"), "color": '#CF8B07', "value": temp[6]};
                    $('#statusGraph').css("line-height", "");
                    statusGraphFunction(combined);
                    },
                    "data": parameters,
                    "error": function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                    } else {
                    console.log("Ajax error!" + textStatus + " " + errorThrown);
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                    $("#alertModal").modal("show");
                    }
                    }
            });
            }
            
            function redirectAssetVulnsReport(){
            var params = {
            'assetId': selectedAsset,
                    'reportType': $('#reportType').val(),
                    'reportName': $('#reportName').val(),
                    'statusGraphData': "",
                    'riskLevelGraphData': "",
                    'assetLevelGraphData': "",
            ${_csrf.parameterName}: "${_csrf.token}"
            };
            if ($('#reportType').val() === '<spring:message code="listVulnerabilities.pdf"/>') {
                blockUILoading();
                statusGraph.exporting.getImage("png").then(function (response) {
                    params["statusGraphData"] = response;
                });
                riskLevelGraph.exporting.getImage("png").then(function (response) {
                    params["riskLevelGraphData"] = response;
                });
            setTimeout(function() {
            generateReport("getAnAssetReport.json", params, "<spring:message code="report.reportCreation"/>",
                    "<spring:message code="listVulnerabilities.reportError"/>");
                    unBlockUILoading();
            }, 10000);
            } else {
            generateReport("getAnAssetReport.json", params, "<spring:message code="report.reportCreation"/>",
                    "<spring:message code="listVulnerabilities.reportError"/>");
                    unBlockUILoading();
            }
            closeReportTypeModal();
            }
            function openReportTypeModal(param){
            $('#selectReportType').modal('show');
            selectedAsset = param;
            riskLevelFunc();
            statusFunc();
            }
            function closeReportTypeModal(){
            $('#reportName').val("");
            $('#reportType').val('<spring:message code="listVulnerabilities.pdf"/>');
            document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
            $('#selectReportType').modal('hide');
            }
            function closeModal() {
            $("#copyAssetModal").removeClass("in");
            $(".modal-backdrop").remove();
            $('body').removeClass('modal-open');
            $('body').css('padding-right', '');
            $("#copyAssetModal").hide();
            $("#newAssetName").val('');
            $("#newAssetIp").val('');
            $("#newAssetHostname").val('');
            $("#newAssetMac").val('');
            $("#assetOtherIps").val([]).change();
            $("#newAssetProps").val([]).change();
            $("#assetImportancyGroup").val([]).change();
            $("#newAssetSeverity").val([]).change();
            $("#assetOperatingSystem").val('');
            $("#newAssetDescription").val('');
            $("#newAssetGroups").val([]).change();
            $("#newAssetType").val([]).change();
            $("#errorCopy").html("");
            document.getElementById("errorCopy").style.visibility = "hidden";
            }
            function openCopyModal(assetId){
            currentAssetId = assetId;
            $('#copyAssetModal').modal({backdrop: 'static', keyboard: false});
            $('#copyAssetModal').modal('show');
            $.post("../customer/getAssetDetails.json",
            {${_csrf.parameterName}: "${_csrf.token}",
                    "assetid": assetId}).done(function (data) {
            $("#newAssetName").val(data.name);
            $("#newAssetIp").val(data.ip);
            $("#newAssetHostname").val(data.hostname);
            $("#newAssetMac").val(data.mac);
            var otherIps = [];
            if (data.otherIps !== null) {
            for (var i = 0; i < data.otherIps.length; i++){
            otherIps.push(data.otherIps[i]);
            }
            }
            $("#assetOtherIps").select2({
            data: otherIps,
                    tags: true
            });
            $('#assetOtherIps').val(data.otherIps).trigger("change");
            $("#assetImportancyGroup").val(data.importancyGroup).change();
            $("#newAssetSeverity").val(data.severity).change();
            $("#newAssetDescription").val(data.description);
            $("#assetOperatingSystem").val(data.operatingSystem);
            if (data.assetType === null){
            $("#newAssetType").val("IP").change();
            }
            else {
            $("#newAssetType").val(data.assetType).change();
            }
            var paramArr = new Array();
            if (data.passiveVulnerabilityParameters.length > 0){
            for (var i = 0; i < data.passiveVulnerabilityParameters.length; i++){
            paramArr[i] = data.passiveVulnerabilityParameters[i].parameter;
            }
            }
            $("#newAssetProps").select2({
            data: [
            <c:forEach items="${assetProps}" var="assetProp">
            {
            id: decodeHtml('<c:out value="${assetProp.parameter}"/>'),
                    text: decodeHtml('<c:out value="${assetProp.parameter}"/>')
            },
            </c:forEach>

            ]
            });
            
            $("#newAssetProps").val(paramArr).trigger("change");
            
            var portArray = new Array();
            var portArrayChange = new Array();
            for (var i = 0; i < data.ports.length; i++){
                portArrayChange[i] = decodeHtml(data.ports[i]['portId']);
                portArray[i] = {};
                portArray[i]['id'] = decodeHtml(data.ports[i]['portId']);
                portArray[i]['text'] = decodeHtml(data.ports[i]['portNumber'] + " (" + data.ports[i]['protocol'] + ")");
            }
            
            var virtualHostArray = new Array();
            var virtualHostArrayChange = new Array();
            for (var i = 0; i < data.hosts.length; i++){
                virtualHostArrayChange[i] = decodeHtml(data.hosts[i]['hostId']);
                virtualHostArray[i] = {};
                virtualHostArray[i]['id'] = decodeHtml(data.hosts[i]['hostId']);
                virtualHostArray[i]['text'] = decodeHtml(data.hosts[i]['name']);
            }
            
            $('#newAssetIp').change(function () {
                let val = $(this).val();
                 $.ajax({
                    "url": "isAssetWithVulnExist.json",
                            "type": "POST",
                            "success": function(data) {
                                assetExist = data;
                            },
                            "data": {'assetName': val,
                                    ${_csrf.parameterName}: "${_csrf.token}"}
                    });
            });
            
            $("#newAssetPorts").select2({
                data: portArray
            });
            $("#newAssetPorts").val(portArrayChange).trigger("change");
            
            
            $("#newAssetVirtualHost").select2({
                data: virtualHostArray
            });
            $("#newAssetVirtualHost").val(virtualHostArrayChange).trigger("change");
                        
            var roleArrayChange = new Array();
            for (var i = 0; i < data.assetRoles.length; i++){
                roleArrayChange[i] = decodeHtml(data.assetRoles[i]['id']);
            }
             $("#newAssetRoles").val(roleArrayChange).trigger("change");
             
            var idArr = new Array();
            if (data.groups.length > 0){
            for (var i = 0; i < data.groups.length; i++){
            idArr[i] = data.groups[i].groupId;
            }
            }
            $("#newAssetGroups").select2({
            data: [
            <c:forEach items="${groups}" var="group">
            {
            id: decodeHtml('<c:out value="${group.groupId}"/>'),
                    text: decodeHtml('<c:out value="${group.name}"/>')
            },
            </c:forEach>

            ]
            });
            $("#newAssetGroups").val(idArr).trigger("change");
            }).fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status === 403) {
            window.location = '../error/userForbidden.htm';
            }
            });
            }
            function copyAndEditAssetHelper() {
                var obj = $("#copyAssetForm").serializeArray();
                obj.push({name: 'newAssetType', value: $("#newAssetType").val()});
                obj.push({name: 'oldAssetId', value: currentAssetId});
                $.ajax({
                "url": "copyAsset.json",
                        "type": "POST",
                        "success": function(data) {
                        if (data.length > 0){
                        var errorCode = "";
                        errorCode += "* " + data;
                        $("#errorCopy").html(errorCode);
                        $("#copyAssetModal").modal('show');
                        document.getElementById("errorCopy").style.visibility = "visible";
                        return;
                        }
                        closeModal();
                        location.reload();
                        },
                        "data": obj,
                        "error": function(jqXHR, status, error) {
                        if (jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                        } else {
                        console.log(status + ": " + error);
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="addAsset.save.error"/>");
                        $("#alertModal").modal("show");
                        }
                        }
                });
            }
            function copyAndEditAsset() {
                if(assetExist) {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listAssets.assetWithVulnExist"/>");
                    $("#alertModal").modal("show");
                } else {
                    copyAndEditAssetHelper();
                }
            
            }
            
        </script>
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        <c:if test="${not empty groupId}">
            <script type="text/javascript">
                var container;
                var morrisDonutChart;
                function am4themes_bizzyTheme(target) {
                if (target instanceof am4core.ColorSet) {
                target.list = [
                        am4core.color("#456173"),
                        am4core.color("#cacaca"),
                        am4core.color("#1b3c59"),
                        am4core.color("#e6b31e"),
                        am4core.color("#f95959"),
                        am4core.color("#f73859"),
                        am4core.color("#f1d18a"),
                        am4core.color("#e6b31e"),
                        am4core.color("#f1e58a"),
                        am4core.color("#344652"),
                        am4core.color("#101f2a"),
                        am4core.color("#ffb143")
                ];
                }
                }
                am4core.useTheme(am4themes_animated);
                am4core.useTheme(am4themes_bizzyTheme);
                am4core.options.commercialLicense = true;
                var vulnCountsByRiskLevel = ${vulnCountsByRiskLevel};
                $(document).ready(function () {

                /* EN ÇOK ZAFİYETE SAHİP 10 IP */
                container = am4core.create("container", am4charts.XYChart3D);
                // Create axes
                container.data = [<c:forEach varStatus="index" var="asset" items="${assetList}">
                    <c:if test="${index.index != 0}">
                ,
                    </c:if>
                {"name":'<c:out value="${asset.ip}"/>', "value": '<c:out value="${asset.vulnerabilityCount}"/>'
                }
                </c:forEach>
                ];
                var categoryAxis = container.xAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";
                categoryAxis.renderer.labels.template.rotation = 315;
                categoryAxis.renderer.labels.template.hideOversized = false;
                categoryAxis.renderer.minGridDistance = 20;
                categoryAxis.renderer.labels.template.horizontalCenter = "right";
                categoryAxis.renderer.labels.template.verticalCenter = "middle";
                categoryAxis.tooltip.label.rotation = 270;
                categoryAxis.tooltip.label.horizontalCenter = "right";
                categoryAxis.tooltip.label.verticalCenter = "middle";
                categoryAxis.renderer.inversed = true;
                var label = categoryAxis.renderer.labels.template;
                label.wrap = true;
                label.maxWidth = 120;
                container.events.on("ready", function () {
                categoryAxis.zoom({
                start: 0,
                        end: 1
                });
                });
                var valueAxis = container.yAxes.push(new am4charts.ValueAxis());
                // Create series
                var series = container.series.push(new am4charts.ColumnSeries3D());
                series.dataFields.valueY = "value";
                series.dataFields.categoryX = "name";
                series.name = "value";
                series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
                series.columns.template.fillOpacity = .8;
                series.columns.template.width = am4core.percent(40);
                series.columns.template.height = am4core.percent(40);
                var columnTemplate = series.columns.template;
                columnTemplate.strokeWidth = 2;
                columnTemplate.strokeOpacity = 1;
                columnTemplate.stroke = am4core.color("#FFFFFF");
                columnTemplate.adapter.add("fill", function(fill, target)  {
                return container.colors.getIndex(target.dataItem.index);
                });
                columnTemplate.adapter.add("stroke", function(stroke, target)  {
                return container.colors.getIndex(target.dataItem.index);
                });
                container.cursor = new am4charts.XYCursor();
                container.cursor.lineX.strokeOpacity = 0;
                container.cursor.lineY.strokeOpacity = 0;
                container.events.on("beforedatavalidated", function (ev) {
                container.data.sort(function (a, b) {
                return (a.value) - (b.value);
                });
                });
                /*  RİSK SEVİYESİNE GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ */
                morrisDonutChart = am4core.create("morrisDonutChart", am4charts.PieChart3D);
                morrisDonutChart.data = [
                {label: "<spring:message code="risk.level.0"/>", value: <c:out value="vulnCountsByRiskLevel[0]"/>},
                {label: "<spring:message code="risk.level.1"/>", value: <c:out value="vulnCountsByRiskLevel[1]"/>},
                {label: "<spring:message code="risk.level.2"/>", value: <c:out value="vulnCountsByRiskLevel[2]"/>},
                {label: "<spring:message code="risk.level.3"/>", value: <c:out value="vulnCountsByRiskLevel[3]"/>},
                {label: "<spring:message code="risk.level.4"/>", value: <c:out value="vulnCountsByRiskLevel[4]"/>},
                {label: "<spring:message code="risk.level.5"/>", value: <c:out value="vulnCountsByRiskLevel[5]"/>}
                ];
                // Add and configure Series
                var pieSeries = morrisDonutChart.series.push(new am4charts.PieSeries());
                pieSeries.dataFields.value = "value";
                pieSeries.dataFields.category = "label";
                pieSeries.colors.list = [
                        new am4core.color('#AADBF9'),
                        new am4core.color('#F9FABB'),
                        new am4core.color('#FEFE60'),
                        new am4core.color('#F8C508'),
                        new am4core.color('#F88008'),
                        new am4core.color('#F80812')
                ];
                pieSeries.innerRadius = am4core.percent(50);
                pieSeries.ticks.template.disabled = true;
                pieSeries.labels.template.disabled = true;
                let rgm = new am4core.RadialGradientModifier();
                rgm.brightnesses.push( - 0.6, - 0.6, - 0.3, 0, - 0.3);
                pieSeries.slices.template.fillModifier = rgm;
                pieSeries.slices.template.strokeModifier = rgm;
                pieSeries.slices.template.strokeOpacity = 0.4;
                pieSeries.slices.template.strokeWidth = 0;
                morrisDonutChart.legend = new am4charts.Legend();
                morrisDonutChart.legend.position = "left";
                morrisDonutChart.marginTop = 0;
                morrisDonutChart.paddingTop = 0;
                morrisDonutChart.legend.properties.marginTop = 0;
                morrisDonutChart.legend.properties.marginBottom = 0;
                morrisDonutChart.legend.scale = 0.8;
                morrisDonutChart.legend.properties.verticalCenter = true;
                morrisDonutChart.legend.margin(0, 0, 0, 0);
                pieSeries.slices.template.interactionsEnabled = true;
                });
            </script>
        </c:if>
        <script type="text/javascript">
            addPortToMultiAssets = function () {
            var assetIds = new Array();
            $('[id=checkAsset]:checked').each(function () {
            var tr = $(this).closest('tr');
            var row = oTable.api().row(tr);
            assetIds.push($(this).val());
            });
            var str = $("#multiAssetAddPortModalForm").serializeArray();
            str.push({name: 'assetIds', value: assetIds});
            str.push({name: 'allRecords', value: $('#checkBoxAllRecords').is(":checked")});
            str.push({name: 'customerId', value: "${custom:escapeForJavascript(customerId)}"});
            str.push({name: 'groupId', value: "${custom:escapeForJavascript(groupId)}"});
            str.push({name: 'newAssets', value: newAssets});
            var obj = createFilterData();
            $.each(obj, function (key, value) {
            str.push({name: value.name, value: value.value});
            });
            $.ajax({
            type: "POST",
                    url: "addPortToMultiAssets.json",
                    data: str,
                    success: function (data) {
                    if (data.errors.length > 0) {
                    var errorCodes = "";
                    for (var i = 0; i < data.errors.length; i++) {
                    errorCodes += "* " + data.errors[i] + "<br/>";
                    }
                    $("#errorPort").html(errorCodes);
                    $("#multiAssetAddPortModal").modal('show');
                    document.getElementById("errorPort").style.visibility = "visible";
                    return;
                    }
                    $('#selectAll').prop("checked", false);
                    closePortModal();
                    oTable.api().draw();
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                    } else {
                    ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                    }
                    }
            });
            };
            function protocolChanged() {
            var protocol = document.getElementById("portProtocol").value;
            if (protocol == 'ICMP') {
            document.getElementById("portNumberAdding").value = '0';
            document.getElementById("portNumberAdding").readOnly = true;
            } else {
            document.getElementById("portNumberAdding").readOnly = false;
            }
            }
            function sendPortForm(){
            addPortToMultiAssets();
            }
            function closePortModal() {
            $("#multiAssetAddPortModal").removeClass("in");
            $(".modal-backdrop").remove();
            $('body').removeClass('modal-open');
            $("#multiAssetAddPortModal").modal('hide');
            $("#portNumberAdding").val('');
            $("#portProtocol").val("-1").change();
            $("#portBanner").val('');
            $("#portService").val('');
            document.getElementById("errorPort").style.visibility = "hidden";
            }

            function allRecordsFunction() {
            if ($('#selectAll').is(":checked")) {
            $('#allRecords').show();
            } else {
            $('#allRecords').hide();
            $("#checkBoxAllRecords").prop('checked', false);
            }
            }

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

            function createFilterData() {
            return $("#searchForm").serializeArray();
            }
             $("#assetGroups").select2({
                        tags: false,
                        multiple: true,
                        ajax: {
                        url: "getAssetGroupList.json",
                            dataType: 'json',
                            type: "post",
                            delay: 0,
                            data: function (params) {
                            var obj = {
                            assetGroupName: params.term,
                                    '${_csrf.parameterName}': "${_csrf.token}"
                            };
                            return obj;
                            },
                            processResults: function (data) {
                            var newResults = [];
                            $.each(data, function(index, item)
                            {
                         
                            newResults.push({
                            id: decodeHtml(item.groupId),
                                    text: decodeHtml(item.name)
                            });
                            });
                            return {
                            results: newResults
                            };
                            },
                            cache: true
                    },
                    minimumInputLength: 3,
                    language: { inputTooShort: function () { return '<spring:message code="generic.selectMinChar"/>'; },
                            searching: function () { return '<spring:message code="generic.selectSearching"/>'; },
                            noResults: function () { return '<spring:message code="generic.selectNoResult"/>'; }
                    }
            });
        </script>

    </jsp:attribute>


    <jsp:body>

        <jsp:include page="include/multiAssetParametersChangeModal.jsp"/>
        <div class="row">
            <div class="col-xs-12" style="margin-top:-24px; z-index: 1">
                <sec:authorize access="hasAnyRole('ROLE_COMPANY_REPORTER,ROLE_PENTEST_ADMIN')">
                    <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                        <c:choose>
                            <c:when test="${not empty groupId}">
                                <a class="btn btn-primary btn-sm" href="addAsset.htm?customerId=<c:out value="${customerId}" />&groupId=<c:out value="${groupId}" />"><spring:message code="listAssets.addAsset"/></a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-primary btn-sm" style="margin-left: 10px" href="addAsset.htm?customerId=<c:out value="${customerId}" />"><spring:message code="listAssets.addAsset"/></a>
                            </c:otherwise>                        
                        </c:choose>
                    </sec:authorize>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('ROLE_COMPANY_REPORTER,ROLE_PENTEST_ADMIN')">
                        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                            <div class="btn-group">
                                <a class="btn btn-sm btn-default btn-info dropdown-toggle" data-toggle="dropdown" href="javascript:;" aria-expanded="false"> 
                                    <spring:message code="listAssets.actions"/>
                                    <i class="fas fa-angle-down"></i>
                                </a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a onclick="assetActions('importAssetFromFile.htm')"> <spring:message code="importAssetFromCsvFile.importFromCsvFile"/> </a>
                                    </li>
                                    <li>
                                        <a onclick="assetActions('redirectReport')"> <spring:message code="listAssets.csvReport"/> </a>
                                    </li>
                                    <li>
                                        <a onclick="assetActions('addPort')"> <spring:message code="listAssets.addPort"/> </a>
                                    </li>
                                    <li>
                                        <a onclick="assetActions('updateAsset')"> <spring:message code="listAssets.updateAsset"/> </a>
                                    </li>
                                    <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN')">
                                        <li>
                                            <a onclick="deleteAssets()"> <spring:message code="listAssets.delete"/> </a>
                                        </li>
                                        <li>
                                            <a onclick="clearAssetWithNoVuln()"> <spring:message code="deleteAssetsNoVulnerability.title"/> </a>
                                        </li>
                                    </sec:authorize>
                                </ul>
                            </div>
                        </sec:authorize>
                    <jsp:include page="../customer/include/reportGraph.jsp" />
                </sec:authorize>
             </div>
            <div class="col-lg-12">                
                <div class="portlet-body" > 
                    <div>
                        <c:if test="${not empty groupId}">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="portlet light bordered">
                                        <div class="portlet-title">
                                            <div class="caption">
                                                <i class="icon-equalizer font-dark hide"></i>
                                                <span class="caption-subject font-dark bold uppercase"> <i class="far fa-chart-bar"></i> <spring:message code="dashboard.top10VulnerableIp"/></span>
                                                <!--  <div class="bizzy-help-tip"   >
                                                      <p> &bull;</p>
                                                  </div> !-->
                                            </div>
                                        </div>
                                        <div class="portlet-body">
                                            <div class="flot-chart">
                                                <div id="container" style="min-width: 300px; height: 400px; margin: 0 auto"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="portlet light bordered">
                                        <div class="portlet-title">
                                            <div class="caption">
                                                <i class="icon-equalizer font-dark hide"></i>
                                                <span class="caption-subject font-dark bold uppercase"> <i class="far fa-chart-bar"></i> <spring:message code="dashboard.riskLevelVulnGraph"/> </span>
                                                <!--    <div class="bizzy-help-tip"   >
                                                        <p> &bull;</p>
                                                    </div> !-->

                                            </div>
                                        </div>
                                        <div class="portlet-body" >
                                            <div id="morrisDonutChart" style="min-width: 300px; height: 400px; margin: 0 auto"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <div id="allRecords" style ="display: none">
                            <input type="checkbox" class="editor-active" id="checkBoxAllRecords">
                                <spring:message code="generic.checkAllRecordsText"/>   
                        </div>
                        <div style="margin-left: 8px">
                            <table class="table table-striped table-bordered table-hover" id="serverDatatables" style="width: 100% !important;">
                                <thead class="datatablesThead">
                                    <tr>
                                        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN')">
                                            <th style="vertical-align: middle;"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('checkAsset'); allRecordsFunction();" ></th>
                                        </sec:authorize>
                                    <th style="vertical-align: middle;"><spring:message code="listAssets.asset"/></th>
                                    <th style="vertical-align: middle;"><spring:message code="listAssets.hostname"/></th>
                                    <th style="vertical-align: middle;"><spring:message code="listAssets.score"/></th>
                                    <th style="vertical-align: middle;"><spring:message code="listAssets.groups"/></th>                                      
                                    <th style="vertical-align: middle;"><spring:message code="listAssets.osAndRoles"/></th>
                                    <th style="vertical-align: middle;"><spring:message code="listAssets.assetProps"/></th>
                                    <th style="vertical-align: middle;white-space:pre-wrap; word-wrap:break-word" width="90px"><spring:message code="listAssets.vulnCount"/></th>
                                    <th style="vertical-align: middle;"> <spring:message code="listAssets.riskDistribution"/></th>                                       
                                    <th style="vertical-align: middle;"> <spring:message code="listAssets.creationDate"/></th>
                                    <th style="vertical-align: middle;" > <spring:message code="listVulnerabilities.status"/></th>
                                    <th style="min-width: 150px;" width="150px"></th>
                                    <th></th>
                                    </tr>
                                    </thead>                                
                            </table> 

                        </div>
                        <a class="btn btn-primary btn-sm" style="margin-left: 4px;" onclick="window.history.back()" title="<spring:message code="generic.back"/>"><i class="fas fa-arrow-left"></i></a>      
                    </div>                    
                </div>
            </div>
        </div>

        <div class="modal fade" id="selectReportType" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="left:-5%">
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
                                <label><spring:message code="listVulnerabilities.reportType"/></label>
                                <select id="reportType" class="selectpicker btn btn-sm btn-default btn-info dropdown-toggle dropdownToggle" onchange="reportTypeChanged();" data-style="btn btn-info btn-sm">
                                    <option value='<spring:message code="listVulnerabilities.pdf"/>'><spring:message code="listVulnerabilities.pdf"/></option>
                                    <option value='<spring:message code="listVulnerabilities.html"/>'><spring:message code="listVulnerabilities.html"/></option>
                                    <option value='<spring:message code="listVulnerabilities.csv"/>'><spring:message code="listVulnerabilities.csv"/></option>
                                    <option value='<spring:message code="listVulnerabilities.word"/>'><spring:message code="listVulnerabilities.word"/></option>
                                </select>
                            </div>
                            <div class="form-group">
                                <p id="statusErrorPTag" style="color:red;visibility:hidden">
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
        <div class="modal fade" id="assetReport" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width:25%">
                <div class="modal-content">
                    <div class="modal-header">
                        <spring:message code="listAssets.report"/>
                    </div>
                    <div class="modal-body">                       
                        <div class="panel-body"> 
                            <div class="form-group required">
                                <label><spring:message code="reviewReport.reportName"/></label>
                                <div style="display:flex;">
                                    <input class="form-control" id ="assetReportName" maxlength="50" style="width:80%;">
                                        <span id ="assetReportExtension" style="width:20%;line-height:3;margin-left:2px;"><b>.csv</b></span>   
                                </div>
                            </div>
                            <div class="form-group">
                                <p id="statusErrorATag" style="color:red;visibility:hidden">
                                    <br><b><spring:message code="report.reportNameValidation"/></b></p>        
                            </div>    
                            <br>
                            <div class="modal-footer" id="download">
                                <div class="row">
                                    <div class="row">
                                        <button type="buttonback" id="buttonback4" onclick="closeAssetReportModal();" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                        <button onClick="assetReportNameControl()" id="downloadAssetReport" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>       
                </div>  
            </div>
        </div>

        <div class="modal fade" id="copyAssetModal" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width:50%">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><spring:message code="listAssets.copyAsset"/></h4>
                    </div>         
                    <div class="modal-body">                       
                        <div class="panel-body"> 
                            <form:form commandName="view" id="copyAssetForm">    
                                <div class="row">
                                    <div class="col-lg-6">                                                             
                                        <div class="form-group" id="selectGroups">                                        
                                            <label><spring:message code="addAsset.group"/></label>
                                            <select name="newAssetGroups" id="newAssetGroups" class="js-example-basic-multiple js-states form-control" multiple style="width: 100%;">                   
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.assetType"/></label>
                                            <select class="form-control" name="newAssetType" id="newAssetType" disabled="true">
                                                <c:forEach items="${assetTypes}" var="assetType">
                                                    <option value="${assetType.name}"><c:out value="${assetType.value}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group required">
                                            <label><spring:message code="addAsset.ip"/></label>                                            
                                            <input class="form-control" name="newAssetIp" id="newAssetIp" placeholder=""/>
                                        </div>
                                        <div>
                                            <p id="errorCopy" style="color:red;visibility:hidden"></p>
                                        </div>
                                        <div class="form-group">                                        
                                            <label><spring:message code="generic.ports"/></label>
                                            <select class="js-example-tags js-example-basic-multiple form-control" name="newAssetPorts" multiple id="newAssetPorts" style="width: 100%;" >
                                            </select>
                                        </div>    
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.hostname"/></label>
                                            <input class="form-control" name="newAssetHostname" id="newAssetHostname" placeholder=""/>
                                        </div>
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.mac"/></label>
                                            <input class="form-control" name="newAssetMac" id="newAssetMac" placeholder=""/>
                                        </div> 
                                        <div class="form-group">                                        
                                             <label><spring:message code="addVirtualHost.host"/></label>
                                            <select class="js-example-tags js-example-basic-multiple form-control" name="newAssetVirtualHost" multiple id="newAssetVirtualHost" style="width: 100%;" >
                                            </select>
                                        </div>
                                    </div>
                                           
                                    <div class="col-lg-6">
                                        <div class="form-group">                                        
                                            <label><spring:message code="listAssets.otherIps"/></label>
                                            <select class="js-example-basic-multiple form-control" name="newAssetOtherIps" id="assetOtherIps" multiple style="width: 100%;">
                                            </select>
                                        </div> 
                                        <div class="form-group">                                        
                                            <label><spring:message code="listAssets.assetProps"/></label>
                                            <select class="js-example-tags js-example-basic-multiple form-control" name="newAssetProps" multiple id="newAssetProps" style="width: 100%;" >
                                            </select>
                                        </div>
                                        <div class="form-group">                                        
                                            <label><spring:message code="listAssetRoles.assetRole"/></label>
                                            <select class="js-example-tags js-example-basic-multiple form-control" name="newAssetRoles" multiple id="newAssetRoles" style="width: 100%;" >
                                                <c:forEach items="${roles}" var="role">
                                                    <c:choose>
                                                        <c:when test="${selectedLanguage == 'en'}">
                                                            <option value="${role.id}"><c:out value="${role.roleNameEn}"/></option>
                                                        </c:when>
                                                        <c:when test="${selectedLanguage == 'tr'}">
                                                             <option value="${role.id}"><c:out value="${role.roleName}"/></option>
                                                        </c:when>
                                                    </c:choose>                                                  
                                                </c:forEach>
                                            </select>
                                        </div>    
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.importancyGroup"/></label>
                                            <select class="form-control" name="newAssetImportancyGroup" id="assetImportancyGroup">
                                                <c:forEach items="${assetImportancies}" var="assetImportancy">
                                                    <option value="${assetImportancy.name}"><c:out value="${assetImportancy.value}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.severity"/></label>
                                            <select class="form-control" name="newAssetSeverity" id="newAssetSeverity">
                                                <c:forEach items="${assetSeverities}" var="assetSeverity">
                                                    <option value="${assetSeverity.name}"><c:out value="${assetSeverity.value}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.description"/></label>
                                            <textarea class="form-control" name="newAssetDescription" id="newAssetDescription" rows="3" placeholder=""></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label><spring:message code="addAsset.operatingSystem"/></label>
                                            <input class="form-control" name="newAssetOperatingSystem" id="assetOperatingSystem" placeholder=""/>
                                        </div>
                                    </div> 
                                </div>
                            </form:form>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button onClick="closeModal()" type="buttonback" id="buttonback4" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                        <button onClick="copyAndEditAsset()" id="submitCopyForm" class="btn btn-success success"><spring:message code="generic.submit"/></button>
                    </div>
                </div>       
            </div> 
        </div>

        <jsp:include page="include/viewAssetModal.jsp" />

        <div class="modal fade" id="multiAssetAddPortModal" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width:35%">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><spring:message code="listAssets.addPort"/></h4>
                    </div>         
                    <div class="modal-body">                       
                        <form:form id="multiAssetAddPortModalForm">        
                            <div class="row">
                                <div class="panel-body">
                                    <div class="form-group required">
                                        <label><spring:message code="addPort.portNumber"/></label>
                                        <input class="form-control" id="portNumberAdding" name="portNumber" placeholder="" onkeypress="validate(event);"  title="*Gerekli" type="number" pattern="[0-9]"/>
                                    </div>
                                    <div class="form-group required">
                                        <label><spring:message code="addPort.protocol"/></label>
                                        <select class="form-control" id="portProtocol" name="portProtocol" onchange="protocolChanged();">
                                            <option value="-1"><spring:message code="addKBItem.selectCategory"/></option>
                                            <option value="TCP">TCP</option>
                                            <option value="UDP">UDP</option>
                                            <option value="ICMP">ICMP</option>
                                            <option value="OTHER">OTHER</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="addPort.banner"/></label>
                                        <input class="form-control" id="portBanner" name="portBanner" placeholder="" type="text"/>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="addPort.service"/></label>
                                        <input class="form-control" id="portService" name="portService" placeholder="" type="text"/>
                                    </div>
                                    <div>
                                        <p id="errorPort" style="color:red;visibility:hidden"></p>
                                    </div>
                                </div>
                            </div>
                        </form:form>                
                    </div>
                    <div class="modal-footer">
                        <button onClick="closePortModal();" type="buttonback" id="buttonback6" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                        <button type="button" onclick="sendPortForm()" class="btn btn-success"><spring:message code="generic.submit"/></button>
                    </div>
                </div>
            </div>                    
        </div>

        <style>
            .popover{
                min-width: 200px;
            }
            .tooltip-inner {
                white-space: pre-wrap;
            }
            .dt-buttons {
                margin-top: 0% !important;
                display: inline;
                z-index: 1;
                left: 6%;
            } 
            .dataTables_length {
                margin-top: 3px !important;
                float: none !important;
                display: inline;
                position: relative;
                bottom:-3140%;
                left: 28%;
                z-index: 2;
            }
        </style>
    </jsp:body>

</biznet:mainPanel>