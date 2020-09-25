<%-- 
    Document   : listScans
    Created on : Sep 27, 2016, 11:36:46 AM
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<biznet:mainPanel viewParams="title,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="main.theme.vulnerabilityScan"/> </span>
            </li>
        </ul>

    </jsp:attribute>

    <jsp:attribute name="alert">

        <c:if test="${not empty error}">
            <div class="alert alert-warning">
                <c:out value="${error}"/>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <spring:message code="${errorMessage}"/>
            </div>
        </c:if>
        <c:if test="${not empty status}">
            <div class="alert alert-success">
                <c:out value="${status}"/>
            </div>
        </c:if>
        <c:if test="${not empty reportStatus}">
            <div class="alert alert-success">
                <spring:message code="${reportStatus}"/>
            </div>
        </c:if>

    </jsp:attribute>

    <jsp:attribute name="button">

        <div class="portlet-body">
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">

                <a class="btn btn-primary btn-sm" id="startScanBtn" data-toggle="modal"><spring:message code="listScans.startScan"/></a>            
                <jsp:include page="../customer/include/reportGraph.jsp" />
                <div class="dropdown btn btn-sm" style="padding:0px;">
                    <sec:authorize access="!hasRole('ROLE_PENTEST_USER')">
                    <a id="dLabel" role="button" data-toggle="dropdown" class="btn btn-success btn-sm" data-target="#" href="/page.html">
                        <spring:message code="listScans.otherActions"/><span class="caret"></span>
                    </a>
                    </sec:authorize>
                    <ul class="dropdown-menu muti-level" role="menu" aria-labelledby="dropdownMenu">
                        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER_READONLY')">
                            <li><a onClick="deleteScans();"><spring:message code="listAssets.delete"/></a></li>
                            </sec:authorize>
                        <li><a href="../pentest/importFromOutput.htm"> <spring:message code="listAssets.import"/> </a></li>
                        <li id="archiveButton"><a onclick="archiveScans();"><spring:message code="listScans.archiveScans"/></a></li>
                        <li class="dropdown-submenu">
                            <a><spring:message code="listScans.difference"/></a>
                            <ul class="dropdown-menu">
                                <li><a onclick="getScanDifferencesGraph('graph')"> <spring:message code="listScans.diffGraphs"/> </a></li>             
                                <li><a onclick="getScanDifferencesGraph('table')"> <spring:message code="listScans.diffTable"/> </a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <sec:authorize access="!hasRole('ROLE_PENTEST_USER')">
                <a><button onClick="refresh()" type="button" class="btn btn-info btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="listScans.refresh"/>"><i class="fas fa-sync"></i> </button></a>
                <a id="showArchiveButton" class="btn btn-warning btn-sm" onclick="archiveClick()"><spring:message code="listScans.showArchives"/></a>    
                </sec:authorize>

            </sec:authorize>
        </div>


    </jsp:attribute>

    <jsp:attribute name="script">

        <script type="text/javascript">
            document.title = "<spring:message code="main.theme.vulnerabilityScan"/> - BIZZY";
            
            $('#fileImportAdd').click(function () {
                if (document.getElementById('fileImportAdd').checked) {
                    $("#addAssetText").css("display", "none");
                    $("#addAssetFile").css("display", "block");
                } else {
                    $("#addAssetText").css("display", "block");
                    $("#addAssetFile").css("display", "none");
                }
            });
            
            function activeTab(tab) {
                $('.nav-tabs a[href="#' + tab + '"]').tab('show');
            }

            var currentTab = 'first';
            function updateCurrentTab(tab) {
                currentTab = tab;        
            }
            $('[href=#tab1default]').on('shown.bs.tab', function (e) {
                updateCurrentTab("first");
                $('#completedScanTableThead').resize();
            });
            $('[href=#tab2default]').on('shown.bs.tab', function (e) {
                updateCurrentTab("second");
                $('#runningScanTableThead').resize();
                refresh();
            });
            $('[href=#tab3default]').on('shown.bs.tab', function (e) {
                updateCurrentTab("third");
                $('#scheduledScanTableThead').resize();
            });
            
            var archivedLoad = "false";
            function archiveClick() {
                if (archivedLoad == "false") {
                    archivedLoad = "true";
                    $('#archiveButton').html('<a onclick="unarchiveScans();"><spring:message code="listScans.unarchiveScans"/></a>');
                    document.getElementById("showArchiveButton").innerHTML = '<span><spring:message code="listScans.showScans"/></span>';
                } else {
                    archivedLoad = "false";
                    $('#archiveButton').html('<a onclick="archiveScans();"><spring:message code="listScans.archiveScans"/></a>');
                    document.getElementById("showArchiveButton").innerHTML = '<span><spring:message code="listScans.showArchives"/></span>';
                }
                oTable.fnDraw();
            }

            function validateAssetInput(str) {
                let arr = str.split(",");
                for (var i = 0; i < arr.length; i++) {
                    arr[i] = arr[i].replace(/\s+/g, '');
                    if (arr[i].indexOf(".") != -1 && arr[i].indexOf("/") != -1) {
                        let splitted = arr[i].split("/");
                        let ip = splitted[0];
                        let range = splitted[1];
                        if (!ValidateIPaddress(ip)) {
                            return false;
                        }
                        let ipDetails = ip.split(".");
                        if (range === parseInt(range, 10)) {
                            return false;
                        }
                        if (ipDetails[3] > range) {
                            return false;
                        }
                    }
                    //validation like 192.168.1.1 - 192.168.2.2
                    else if (arr[i].indexOf(".") != -1 && arr[i].indexOf("-") != -1) {
                        let splitted = arr[i].split("-");
                        let ip = splitted[0];
                        let ip2 = splitted[1];
                        if (!(ValidateIPaddress(ip) && ValidateIPaddress(ip2))) {
                            return false;
                        }
                    } else if (arr[i].match(/^[0-9\\.]+$/)) {
                        if (!ValidateIPaddress(arr[i])) {
                            return false;
                        }
                    }
                }
                return true;
            }
            function ValidateIPaddress(ipaddress) {
                if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress)) {
                    return true;
                }
                return false;
            }
            $(window).on('beforeunload', function () {
            });
           


            

            
            $("#startScanBtn").click(function () {
                window.location = "startScan.htm";
            });
            var oTable;
            var oTable2;
            var oTable3;
            $(document).ready(function () {
                var url_string = window.location.href;
                if (url_string.includes("scheduled")) {
                    activeTab('tab3default');
                } else if (url_string.includes("running")) {
                    activeTab('tab2default');
                }
                $('[data-toggle="tooltip"]').tooltip();
                $("[data-toggle=popover]").popover();
                if (localStorage.getItem("activeScan") === "true") {
                    localStorage.setItem("activeScan", "false");
                    activeTab('tab2default');
                }
                if (localStorage.getItem("scanCreated") === 'listScheduled') {
                    activeTab('tab3default');
                    localStorage.setItem("scanCreated", null);
                } 

                var timeoutVar;
                var waitingTime = 180000;
                
                
                oTable = $('#completedScanTable').dataTable({ //TAMAMLANAN TARAMALAR
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "processing": true,
                    "serverSide": true,
                    "scrollX": true,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', width: 10, targets: 0 },
                        { className: 'noVis', targets: 12 }
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "language": {
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                        "processing": '<div class="allVulnTable_processing"><spring:message code="generic.tableLoading"/></div>',
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
                        {data: "scanId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" id="selectedScan" style="display:block; margin:0 auto; vertical-align:middle; " value="' + data + '" >';
                                }
                                return data;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'name'},
                        {
                            "data": function (data) {
                                var status = decodeHtml(data.status.value);
                                switch (status) {
                                    case "QUEUED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.queued"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/arrowR.svg" width="25"/></div>';
                                    case "ERROR" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.errorInScan"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    case "EMPTY" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.empty"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    case "COMPLETED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.completed"/>"  style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/check.svg" width="25"/></div>';
                                    case "SCHEDULED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.scheduled"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/time.svg" width="25"/></div>';
                                    case "IMPORTING" :
                                        return '<div class="progress"><div id="' + data.scanId + '" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="0" style="width:0%">%0</d></div>';
                                    case "RUNNING" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.running"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/oval.svg" width="25"/></div>';
                                    case "CANCELED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="ScanStatus.CANCELED"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    default :
                                        return '<div class="riskLevel2 riskLevelCommon">'+ data.status.name +'</div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'scanDate'},
                        {"data": function (data, type, dataToSet) {
                                var html = '<a class ="btn btn-link btn-sm" data-toggle="tooltip" data-placement ="top" title ="<spring:message code="generic.detail"/>" onclick="showModal(\'' + data.scanId + '\')"> <i class="fas fa-ellipsis-h"></i></a> ';
                                return html;
                            }, "searchable": false, "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.excludeIps === "" || data.excludeIps === null) {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.excludeIps;
                                }
                            }, "orderable": false, "searchable": false},
                        {"data": 'vulnerabilityCount', "searchable": false, "orderable": false},
                        {"data": 'assetCount', "searchable": false, "orderable": false},
                        {"data": 'source', "searchable": false, "orderable": false,
                            "render": function (data) {
                                return getScannerLogo(data, '${pageContext.request.contextPath}');
                            }
                        },
                        {"data": 'policy.name',
                            "render": function (data) {
                                if (data !== null && data !== "") {
                                    return data;
                                } else {
                                    return '<i class="fas fa-minus"></i>';
                                }
                            }
                        },
                        {"data": 'requestDate'},
                        
                        {"data":function (data) {
                         var isChrome = !!window.chrome && (!!window.chrome.webstore || !!window.chrome.runtime);
                         var dateComp,dateScan;
                        if(data.completionDate!=null && data.scanDate!=null){
                            
                            if(isChrome){
                                var splitComp = (data.completionDate).split(".");
                                var newComp= splitComp[1] + "."+ splitComp[0] +"." + splitComp[2];

                                var splitScan = (data.scanDate).split(".");
                                var newScan= splitScan[1] + "."+ splitScan[0] +"." + splitScan[2];
                                
                            }else{
                                var splitComp = (data.completionDate).split(".");
                                var splitCompDateTime = (splitComp[2]).split(" ");
                                var newComp= parseInt(splitComp[1])+ "/" + parseInt(splitComp[0]) + "/" + parseInt(splitCompDateTime[0]) + " " + splitCompDateTime[1] ;                               
                                var splitScan = (data.scanDate).split(".");
                                var splitScanDateTime = (splitScan[2]).split(" ");
                                var newScan= parseInt(splitScan[1])+ "/" + parseInt(splitScan[0]) + "/" + parseInt(splitScanDateTime[0]) + " " + splitScanDateTime[1] ;  
                            }
                            dateComp=new Date(newComp);
                            dateScan=new Date(newScan);
                        }else{
                             return '<i class="fas fa-minus"></i>';
                         };
                        
                        if (dateComp!==null && dateScan!==null) {
                           function timeDiffCalc(dateFuture, dateNow) { 
                           let diffInMilliSeconds = Math.abs(dateFuture - dateNow) / 1000;
                           var days = Math.floor(diffInMilliSeconds / 86400);
                           diffInMilliSeconds -= days * 86400;
                           var hours = Math.floor(diffInMilliSeconds / 3600) % 24;
                           diffInMilliSeconds -= hours * 3600;
                           var minutes = Math.floor(diffInMilliSeconds / 60) % 60;
                           diffInMilliSeconds -= minutes * 60;
                           let difference = '';
                           if (days > 0) {
                             difference += (days === 1) ? days+ " Gün " : days+" Gün ";
                           }
                           if (hours > 0) {
                                difference += (hours === 0 || hours === 1) ? hours+" saat " : hours+" saat ";
                           }
                           difference += (minutes === 0 || hours === 1) ? +minutes+" dakika" : minutes+" dakika"; 
                           return difference;
                         }    
                        var timestring = timeDiffCalc(dateComp, dateScan);
                                if (data !== null && data !== "") {
                                    return data.completionDate + "<br>" + timestring;
                                } else {
                                    return '<i class="fas fa-minus"></i>';
                                }
                            }else{
                                return '<i class="fas fa-minus"></i>';
                            }
                                
                            }
                        },

                        {"data": function (data, type, dataToSet) {
                                return getScanActions(data);
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "order": [3, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadScans.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}",
                                    d.isArchiveActive = archivedLoad,
                                    d.sourceFilter = $('#sourceFilter').val();
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listQualysScans.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $("#warningRowUpdate").hide();
                        if (waitingTime !== -1) {
                            clearTimeout(timeoutVar);
                            timeoutVar = window.setTimeout(update, waitingTime);
                        }
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                        $("#tabCompletedHeader").html('<spring:message code="listScans.completedScans"/>' + ' (' + oSettings._iRecordsTotal + ')');
                    },
                    "initComplete": function (settings, json) {
                        oTable.fnAdjustColumnSizing();
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                    }
                });
                oTable2 = $('#runningScanTable').dataTable({//DEVAM EDEN TARAMALAR
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "processing": true,
                    "serverSide": true,
                    "stateSave": true,
                    "scrollX": true,
                    "columnDefs": [
                        { className: 'noVis2', width: 10, targets: 0 },
                        { className: 'noVis2', targets: 9 },
                        { width: "17%", targets: 9}
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis2)'
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
                    "columns": [
                        {
                            data: "scanId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" style="display:block; margin:0 auto; vertical-align:middle; " id="selectedScanD" value="' + data + '" >';
                                }
                                return data;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'name'},
                        {
                            "data": function (data) {
                                var status = decodeHtml(data.status.value);
                                switch (status) {
                                    case "QUEUED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.queued"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/arrowR.svg" width="25"/></div>';
                                    case "ERROR" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.empty"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    case "EMPTY" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.empty"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    case "COMPLETED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.completed"/>"  style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/check.svg" width="25"/></div>';
                                    case "SCHEDULED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.scheduled"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/time.svg" width="25"/></div>';
                                    case "IMPORTING" :
                                        return '<div class="progress"><div id="' + data.scanId + '" class="progress-bar progress-bar-success" role="progressbar" data-toggle="tooltip" data-placement ="right" aria-valuenow="' + data.progress + '" aria-valuemin="0" title="" aria-valuemax="0" style="width:' + data.progress + '%">%' + data.progress + '</div></div>';
                                    case "RUNNING" :
                                        if(data.source === "NETSPARKERENT") {
                                            return '<div class="progress"><div id="' + data.scanId + '" class="progress-bar progress-bar-success" data-toggle="tooltip" data-placement ="right" role="progressbar" aria-valuenow="' + data.progress + '" aria-valuemin="0" aria-valuemax="0" title="" style="width:' + data.progress + '%">%' + data.progress + ' </div></div>';
                                        } else {
                                            return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.running"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/oval.svg" width="25"/></div>';
                                        }
                                    case "CANCELED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="ScanStatus.CANCELED"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    default :
                                        return '<div class="riskLevel2 riskLevelCommon">'+ data.status.name +'</div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'scanDate'},
                        {"data": function (data, type, dataToSet) {
                                if(data.targets !== null) {
                                    var targets = data.targets;
                                    if (targets.length < 45) {
                                        return data.targets;
                                    } else {
                                        var shortString = targets.substring(0, 45);
                                        return '<p data-toggle="tooltip" data-placement="right" title="' + data.targets + '">"' + shortString + '"</p>';
                                    }
                                } else {
                                    return '';
                                }
                               
                            }, "searchable": false, "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.excludeIps == "" || data.excludeIps == null) {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.excludeIps;
                                }
                            }, "orderable": false, "searchable": false},
                        {"data": 'source', "searchable": false, "orderable": false,
                            "render": function (data) {
                                return getScannerLogo(data, '${pageContext.request.contextPath}');
                            }
                        },
                        {"data": 'policy.name',
                            "render": function (data) {
                                if (data !== null && data !== "") {
                                    return data;
                                } else {
                                    return '<i class="fas fa-minus"></i>';
                                }
                            }
                        },
                        {"data": 'requestDate'},
                        {"data": function (data, type, dataToSet) {
                                return '<a data-toggle="modal" data-target="#scanDetails"><button onClick="openDetails(\'' + data.scanId + '\',\'normal\')"  class="btn btn-default btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="listScans.scanDetails"/>"><i class="fas fa-asterisk"></i></button></a> ';
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "order": [3, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadRunningScans.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}",
                                    d.sourceFilter = $('#sourceFilter2').val();
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listQualysScans.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $("#warningRowUpdate").hide();
                        if (waitingTime !== -1) {
                            clearTimeout(timeoutVar);
                            timeoutVar = window.setTimeout(update, waitingTime);
                        }
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                        $("#tabRunningHeader").html('<spring:message code="listScans.runningScans"/>' + ' (' + oSettings._iRecordsTotal + ')');
                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        oTable2.fnAdjustColumnSizing();
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                        setTimeout(function() {
                            refresh();
                        }, 1000);
                    }
                });
                oTable3 = $('#scheduledScanTable').dataTable({//PLANLI TARAMALAR
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "processing": true,
                    "serverSide": true,
                    "stateSave": true,
                    "scrollX": true,
                    "columnDefs": [
                        { className: 'noVis', width: 10, targets: 0 },
                        { className: 'noVis', targets: 13 },
                        { width: "17%", targets: 10}
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
                        }
                    ],
                    "bSortClasses": false,
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
                    "fnRowCallback": function (row, data, index) {
                        let reccurence = data.recurrence;
                        let occurrence = data.occurrence;
                        if (occurrence !== "ON_DEMAND" && reccurence != -1) {
                            let completed = data.completedScanCount;
                            let remaining = reccurence - completed;
                            let threshold = Math.ceil(reccurence / 10);
                            if (remaining <= threshold) {
                                $('td', row).css('background-color', '#FF6666');
                            }
                        }
                    },
                    "columns": [
                        {
                            data: "scanId",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox"  style="display:block; margin:0 auto; vertical-align:middle;" id="selectedScanP" value="' + data + '" >';
                                }
                                return data;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'name'},
                        {"data": function (data, type, dataToSet) {
                                return getScheduledScanStatusAction(data);
                            },
                            "searchable": false,
                            "orderable": false,
                            "width": "20%"
                        },
                        {"data": function (data, type, dataToSet) {
                                var result;
                                if (data.succedded === "true") {
                                    result = '<i class="far fa-check-circle"></i>';
                                } else if (data.succedded === "false") {
                                    result = '<i class="far fa-times-circle"></i>';
                                }
                                if (data.previousScanDate == "-") {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.previousScanDate + " " + result;
                                }
                                if (data.nextScanDate == "-") {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.nextScanDate + " " + result;
                                }
                            }, "orderable": false, "searchable": false},
                        {"data": function (data, type, dataToSet) {
                                return data.nextScanDate;
                            }, "orderable": false, "searchable": false},
                        {"data": function (data, type, dataToSet) {
                                return data.completedScanCount;
                            }, "orderable": false, "searchable": false},
                        {"data": function (data, type, dataToSet) {
                                if (data.recurrence === -1) {
                                    var html = '</div><spring:message code="scheduledScans.CompletedScanCount"/></a>';
                                    return html;
                                } else {
                                    return data.recurrence - data.completedScanCount;
                                }

                            }, "orderable": false, "searchable": false},
                        {"data": function (data, type, dataToSet) {
                                if (data.recurrence === -1) {
                                    var html = '</div><spring:message code="scheduledScans.CompletedScanCount"/></a>';
                                    return html;
                                } else {
                                    return data.recurrence;
                                }

                            }, "orderable": false, "searchable": false},
                        {"data": 'occurrence', "orderable": false, "searchable": false},
                        {"data": function (data, type, dataToSet) {
                                if(data.targets !== null) {
                                    var targets = data.targets;
                                    if (targets.length < 45) {
                                        return data.targets;
                                    } else {
                                        var shortString = targets.substring(0, 45);
                                        return '<p data-toggle="tooltip" data-placement="right" title="' + data.targets + '">"' + shortString + '"</p>';
                                    }
                                } else {
                                    return '';
                                }
                            }, "orderable": false, "searchable": false
                        },
                        {"data": 'source', "searchable": false, "orderable": false,
                            "render": function (data) {
                                return getScannerLogo(data, '${pageContext.request.contextPath}');
                            }
                        },
                        {"data": 'policy.name',
                            "render": function (data) {
                                if (data !== null && data !== "") {
                                    return data;
                                } else {
                                    return '<i class="fas fa-minus"></i>';
                                }
                            }
                        },
                        {"data": 'requestDate'},
                        {"data": function (data, type, dataToSet) {
                                return getScheduledScanActions(data);
                            },
                            "searchable": false,
                            "orderable": false,
                            "width": "20%"
                        }
                    ],
                    "order": [12, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadScheduledScans.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}",
                                    d.sourceFilter = $('#sourceFilter3').val();
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listQualysScans.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    },
                    "fnDrawCallback": function (oSettings) {
                        $("#warningRowUpdate").hide();
                        if (waitingTime !== -1) {
                            clearTimeout(timeoutVar);
                            timeoutVar = window.setTimeout(update, waitingTime);
                        }
                        $('[data-toggle="tooltip"]').tooltip();
                        $("#tabScheduledHeader").html('<spring:message code="listScans.scheduledScans"/>' + ' (' + oSettings._iRecordsTotal + ')');
                        $("[name*='active-']").bootstrapSwitch();
                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        oTable3.fnAdjustColumnSizing();
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    }
                });
                function update() {
                    oTable.api().ajax.reload();
                }
                ;
                $('.dataTables_filter input')
                        .unbind()
                        .bind('keypress keyup', function (e) {
                            var length = $(this).val().length;
                            var keyCode = e.keyCode;
                            if (length >= 3 && keyCode === 13) {
                                oTable.fnFilter($(this).val());
                                oTable2.fnFilter($(this).val());
                                oTable3.fnFilter($(this).val());
                            } else if (length === 0) {
                                oTable.fnFilter("");
                                oTable2.fnFilter("");
                                oTable3.fnFilter("");
                            }
                        }).attr("placeholder", decodeHtml("<spring:message code="listQualysScans.searchTip" htmlEscape="false"/>")).width('220px');
            });
            function getScanType(data) {
                if (data.scheduled) {
                    return 'SCHEDULED';
                } else {
                    return 'ONE TIME';
                }
            }
            function getScanActions(data) {
                var html = '<div class="dropdown"><button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu pull-right">';

                var state = data.status.value;
                if (data.resultsSaved) {
                    html += '<li><a  href="viewScanResults.htm?scanId=' + data.scanId + '" data-toggle="tooltip" data-placement="top"><spring:message code="listScans.viewResult"/></a></li>  ';
                    if (data.vulnerabilityCount > 0) {
                        html += '<li><a  data-toggle="modal" data-target="#selectReportType" onClick="openModal(\'' + data.scanId + '\')" > <spring:message code="listScans.report"/></a></li>  ';
                        html += '<li><a  data-toggle="modal" data-target="#bddkReport" onClick="openModal(\'' + data.scanId + '\')" > <spring:message code="listScans.bddkReport"/></a></li>  ';
                    }
                }
                html += '<li><a  data-toggle="modal" data-target="#scanDetails" onClick="openDetails(\'' + data.scanId + '\',\'normal\')"><spring:message code="listScans.scanDetails"/></a></li> ';
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">
                if (state === 'SCHEDULED') {
                    html += '</ul></div>';
                    return html;
                } else if (state === 'COMPLETED' || state === 'FINISHED') {

                    html += '<li><a  data-toggle="modal" data-target="#addAsset" onClick="addAssetToScanFunction(\'' + data.scanId + '\')" ><spring:message code="listAssetGroups.addAsset"/> / <spring:message code="multiVulnerabilityParametersChangeModal.remove"/></a></li> ';
                    html += '<li><a  data-toggle="modal" data-target="#editName" onClick="editScanName(\'' + data.scanId + '\')" ><spring:message code="listScans.editName"/></a></li> ';
                    if (data.source === 'PENTEST') {
                        html += '<li><a  onClick="copyScan(\'' + data.scanId + '\')" name="copy"><spring:message code="listScans.copy"/></a></li>';
                        html += '<li><a  onClick="exportPentestScan(\'' + data.scanId + '\')"><spring:message code="listScans.pentestExport"/></a></li>';
                    } else {
                        if(!data.syncScan) {
                            html += '<li><a  data-toggle="modal" data-target="#rescan" onClick="rescanFunction(\'' + data.scanId + '\')"><spring:message code="listScans.rescan"/></a></li>';
                        }
                    }
                }
                if (state === 'RUNNING') {
                    html += '<li><a data-toggle="modal" data-target="#scanDetails" onClick="openDetails(\'' + data.scanId + '\',\'normal\')"><spring:message code="listScans.scanDetails"/></a></li>';
                    html += '<li><a onClick="deleteRow(\'' + data.scanId + '\', this)" name="delete" data-toggle="tooltip" data-placement="top"><spring:message code="listScans.stopAndDelete"/></a> </li>  ';
                }
            </sec:authorize>
                html += '</ul></div>';
                return html;
            }
            var changeCheck = 0;
            function getScheduledScanActions(data) {
                var html = '<div class="dropdown"><button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">
                if(!data.customizedScan) {
                    html += '<li><a style="width: 31px; height:28px" href="editScheduledScan.htm?scanId=' + data.scanId + '" ><spring:message code="generic.edit"/></a></li>  ';
                }
                html += '<li><a onClick="deleteScheduledRow(\'' + data.scanId + '\', this)" name="delete" ><spring:message code="generic.delete"/></a></li>  ';
                html += '<li><a data-toggle="modal" data-target="#scanDetails" onClick="openDetails(\'' + data.scanId + '\',\'scheduled\')" ><spring:message code="listScans.scanDetails"/></a></li> ';
                if(!data.customizedScan) {
                    html += '<li><a data-toggle="modal" data-target="#scanNow" onClick="startScanNow(\'' + data.scanId + '\')" ><spring:message code="listScans.startImmediately"/></a></li> ';
                }    
            </sec:authorize>
                html += '</ul></div>';
                return html;
            }
            function getScheduledScanStatusAction(data) {
                var html = '';
                if (data.active) {
                    html += '<spring:message code="listScans.active"/>';
                } else {
                    html += '<spring:message code="genericdb.passive"/>';
                }
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">
                html = '';
                if (data.customizedScan) {
                    $("[name = 'active-" + data.scanId + "']").bootstrapSwitch('disabled',true);
                } else {
                    $("[name = 'active-" + data.scanId + "']").bootstrapSwitch();
                }
                $("#scheduledScanTable").on('switchChange.bootstrapSwitch', "input[name='active-" + data.scanId + "']", function (event, state) {
                    sendAjaxOnClick(data.scanId, state);
                });
                var checkState = "";
                if (data.active)
                    checkState = "checked";
                html += '<a><input type="checkbox" name="active-' + data.scanId + '" data-size="small" data-on-text="<spring:message code="listScans.active"/>" data-off-text="<spring:message code="genericdb.passive"/>" onclick="onClickHandler()" ' + checkState + '></a>';
            </sec:authorize>
                return html;
            }

            function sendAjaxOnClick(scanId, status) {
                changeCheck += 1;
                if(changeCheck === 1){
                    $.ajax({
                    type: "POST",
                    url: "changeScheduledScanStatus.json",
                    data: {"scanId": scanId, "status": status, "${_csrf.parameterName}": "${_csrf.token}"},
                    success: function (data) {
                        changeCheck = 0;
                        if (data.success) {
                            return;
                        } else {
                            alert("ERROR");
                            return;
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                    }
                    });
                }
                
            }

            function deleteRow(id, deletedElement) {

                function confirmDelete() {
                    blockUILoading();
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteScan.json", {scanId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {

                    }).done(function () {
                        oTable.fnDeleteRow(nRow);
                        oTable.fnDraw();
                        oTable2.fnDraw();
                        unBlockUILoading();
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                        unBlockUILoading();
                    }).always(function () {
                    });
                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="generic.confirmDeleteScan"/>"), confirmDelete);
            }


            function deleteScheduledRow(id, deletedElement) {

                function confirmDeleteScheduled() {

                    blockUILoading();
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteScheduledScan.json", {scanId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        oTable.fnDraw();
                        oTable2.fnDraw();
                        oTable3.fnDeleteRow(nRow);
                        unBlockUILoading();
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                        unBlockUILoading();
                    }).always(function () {
                        localStorage.setItem("scanCreated", "listScheduled");
                        location.reload();
                    });
                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listScans.deleteWarning"/>"), confirmDeleteScheduled);
            }

            var differenceIds;
            $("#diffTableModal").on('shown.bs.modal',function(){
               $("#scanDiffTableThead").resize();
            });
            function getScanDifferencesGraph(param) {
                var scansIds = [];
                $('[id=selectedScan]:checked').each(function () {
                    scansIds.push($(this).val());
                });
                var data;
                if (param === "table") {
                    if (scansIds.length === 2) {
                        $("#diffTableModal").modal();
                        differenceIds = JSON.stringify(scansIds);
                        if(recreateDiff === true){
                            diffTable.api().ajax.reload();
                        } else 
                            loadScanDiffTable();
                    } else {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.diffWarning"/>");
                        $("#alertModal").modal("show");
                        differenceIds = "";
                        scansIds = [];
                    }
                } else {
                    if (scansIds.length < 5 && scansIds.length > 1) {
                        $.post("scanDiffGraph.json", {
                            'scansIds': scansIds, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function (data) {
                            $("#diffGraphModal").modal();
                            loadScanDiffGraphs(data);
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                            $("#alertModal").modal("show");
                        }).always(function () {
                        });
                    } else {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.error"/>");
                        $("#alertModal").modal("show");
                        differenceIds = "";
                        scansIds = [];
                    }
                }

            }
            function onlyDiffFunction() {
                diffTable.api().ajax.reload();
            }

            var assetCountsDiffIndicator;
            var assetCountsDiff = null;
            var vulnerabilityCountsDiffIndicator;
            var vulnerabilityCountsDiff = null;
            var riskScoreDiffIndicator;
            var riskScoreDiff = null;

            function loadScanDiffGraphs(data) {

                function am4themes_bizzyTheme(target) {
                    if (target instanceof am4core.ColorSet) {
                        target.list = [
                            am4core.color("#456173"),
                            am4core.color("#cacaca"),
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

                if (assetCountsDiff !== null) {
                    assetCountsDiff.dispose();
                }
                if (vulnerabilityCountsDiff !== null) {
                    vulnerabilityCountsDiff.dispose();
                }
                if (riskScoreDiff !== null) {
                    riskScoreDiff.dispose();
                }

                am4core.options.commercialLicense = true;
                am4core.useTheme(am4themes_animated);
                am4core.useTheme(am4themes_bizzyTheme);

                var scans = data.scans;
                var assetCounts = data.assetCounts;
                var level4or5AssetCounts = data.level4or5AssetCounts;

                assetCountsDiff = am4core.create("assetCountsDiff", am4charts.XYChart);
                assetCountsDiff.data = [];
                var categoryAxis = assetCountsDiff.xAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";
                categoryAxis.renderer.grid.template.location = 0;
                var label = categoryAxis.renderer.labels.template;
                label.wrap = true;
                var valueAxis = assetCountsDiff.yAxes.push(new am4charts.ValueAxis());
                valueAxis.renderer.inside = true;
                valueAxis.renderer.labels.template.disabled = true;
                valueAxis.min = 0;
                function createSeries(field, name) {
                    var series = assetCountsDiff.series.push(new am4charts.ColumnSeries());
                    series.name = name;
                    series.dataFields.valueY = field;
                    series.dataFields.categoryX = "name";
                    series.sequencedInterpolation = true;
                    series.stroke = am4core.color("#ffffff");
                    series.stacked = true;
                    series.columns.template.width = am4core.percent(60);
                    series.columns.template.tooltipText = "[bold]{categoryX.id}[/]\n[font-size:14px]" + series.name + ": {valueY}";
                    var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                    labelBullet.label.text = "{valueY}";
                    labelBullet.locationY = 0.5;
                    series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                    return series;
                }
                var scanCount = 0;
                for (var i = 0; i < scans[0].length; i++) {
                    createSeries("scan" + i, scans[0][i]);
                    scanCount += 1;
                }
                assetCountsDiffIndicator = assetCountsDiff.tooltipContainer.createChild(am4core.Container);
                assetCountsDiffIndicator.background.fill = am4core.color("#fff");
                assetCountsDiffIndicator.background.fillOpacity = 0.8;
                assetCountsDiffIndicator.width = am4core.percent(100);
                assetCountsDiffIndicator.height = am4core.percent(100);
                var assetCountsDiffIndicatorLabel = assetCountsDiff.createChild(am4core.Label);
                assetCountsDiffIndicatorLabel.text = "";
                assetCountsDiffIndicatorLabel.align = "center";
                assetCountsDiffIndicatorLabel.valign = "middle";
                assetCountsDiffIndicatorLabel.fontSize = 12;
                var values = [];
                if (scanCount === 2) {
                    values[0] = {"name": "<spring:message code="listAssetGroups.assetsCount"/>", "scan0": assetCounts[0][0], "scan1": assetCounts[0][1]};
                    values[1] = {"name": "<spring:message code="listScans.level5and4"/>", "scan0": level4or5AssetCounts[0][0], "scan1": level4or5AssetCounts[0][1]};
                } else if (scanCount === 3) {
                    values[0] = {"name": "<spring:message code="listAssetGroups.assetsCount"/>", "scan0": assetCounts[0][0], "scan1": assetCounts[0][1], "scan2": assetCounts[0][2]};
                    values[1] = {"name": "<spring:message code="listScans.level5and4"/>", "scan0": level4or5AssetCounts[0][0], "scan1": level4or5AssetCounts[0][1], "scan2": level4or5AssetCounts[0][2]};
                } else if (scanCount === 4) {
                    values[0] = {"name": "<spring:message code="listAssetGroups.assetsCount"/>", "scan0": assetCounts[0][0], "scan1": assetCounts[0][1], "scan2": assetCounts[0][2], "scan3": assetCounts[0][3]};
                    values[1] = {"name": "<spring:message code="listScans.level5and4"/>", "scan0": level4or5AssetCounts[0][0], "scan1": level4or5AssetCounts[0][1], "scan2": level4or5AssetCounts[0][2], "scan3": level4or5AssetCounts[0][3]};
                }
                if (values.length === 0) {
                    assetCountsDiff.data = [];
                    assetCountsDiffIndicator.show();
                } else {
                    $('#assetCountsDiff').css("line-height", "");
                    assetCountsDiff.data = values;
                    assetCountsDiffIndicator.hide();
                }

                var level4or5vulnerabilityCounts = data.level4or5vulnerabilityCounts;
                var level3vulnerabilityCounts = data.level3vulnerabilityCounts;
                var level2vulnerabilityCounts = data.level2vulnerabilityCounts;
                var level1vulnerabilityCounts = data.level1vulnerabilityCounts;

                vulnerabilityCountsDiff = am4core.create("vulnerabilityCountsDiff", am4charts.XYChart);
                vulnerabilityCountsDiff.data = [];
                var categoryAxis2 = vulnerabilityCountsDiff.xAxes.push(new am4charts.CategoryAxis());
                categoryAxis2.dataFields.category = "name";
                categoryAxis2.renderer.grid.template.location = 0;
                var label2 = categoryAxis2.renderer.labels.template;
                label2.wrap = true;
                var valueAxis2 = vulnerabilityCountsDiff.yAxes.push(new am4charts.ValueAxis());
                valueAxis2.renderer.inside = true;
                valueAxis2.renderer.labels.template.disabled = true;
                valueAxis2.min = 0;
                function createSeries2(field, name) {
                    var series = vulnerabilityCountsDiff.series.push(new am4charts.ColumnSeries());
                    series.name = name;
                    series.dataFields.valueY = field;
                    series.dataFields.categoryX = "name";
                    series.sequencedInterpolation = true;
                    series.stroke = am4core.color("#ffffff");
                    series.stacked = true;
                    series.columns.template.width = am4core.percent(60);
                    series.columns.template.tooltipText = "[bold]{categoryX.id}[/]\n[font-size:14px]" + series.name + ": {valueY}";
                    var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                    labelBullet.label.text = "{valueY}";
                    labelBullet.locationY = 0.5;
                    series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                    return series;
                }
                var scanCount2 = 0;
                for (var i = 0; i < scans[0].length; i++) {
                    createSeries2("scan" + i, scans[0][i]);
                    scanCount2 += 1;
                }
                vulnerabilityCountsDiffIndicator = vulnerabilityCountsDiff.tooltipContainer.createChild(am4core.Container);
                vulnerabilityCountsDiffIndicator.background.fill = am4core.color("#fff");
                vulnerabilityCountsDiffIndicator.background.fillOpacity = 0.8;
                vulnerabilityCountsDiffIndicator.width = am4core.percent(100);
                vulnerabilityCountsDiffIndicator.height = am4core.percent(100);
                var vulnerabilityCountsDiffIndicatorLabel = vulnerabilityCountsDiff.createChild(am4core.Label);
                vulnerabilityCountsDiffIndicatorLabel.text = "";
                vulnerabilityCountsDiffIndicatorLabel.align = "center";
                vulnerabilityCountsDiffIndicatorLabel.valign = "middle";
                vulnerabilityCountsDiffIndicatorLabel.fontSize = 12;
                var values2 = [];
                if (scanCount2 === 2) {
                    values2[0] = {"name": "<spring:message code="listScans.dangandcrit"/>", "scan0": level4or5vulnerabilityCounts[0][0], "scan1": level4or5vulnerabilityCounts[0][1]};
                    values2[1] = {"name": "<spring:message code="dashboard.level3"/>", "scan0": level3vulnerabilityCounts[0][0], "scan1": level3vulnerabilityCounts[0][1]};
                    values2[2] = {"name": "<spring:message code="dashboard.level2"/>", "scan0": level2vulnerabilityCounts[0][0], "scan1": level2vulnerabilityCounts[0][1]};
                    values2[3] = {"name": "<spring:message code="dashboard.level1"/>", "scan0": level1vulnerabilityCounts[0][0], "scan1": level1vulnerabilityCounts[0][1]};
                } else if (scanCount2 === 3) {
                    values2[0] = {"name": "<spring:message code="listScans.dangandcrit"/>", "scan0": level4or5vulnerabilityCounts[0][0], "scan1": level4or5vulnerabilityCounts[0][1], "scan2": level4or5vulnerabilityCounts[0][2]};
                    values2[1] = {"name": "<spring:message code="dashboard.level3"/>", "scan0": level3vulnerabilityCounts[0][0], "scan1": level3vulnerabilityCounts[0][1], "scan2": level3vulnerabilityCounts[0][2]};
                    values2[2] = {"name": "<spring:message code="dashboard.level2"/>", "scan0": level2vulnerabilityCounts[0][0], "scan1": level2vulnerabilityCounts[0][1], "scan2": level2vulnerabilityCounts[0][2]};
                    values2[3] = {"name": "<spring:message code="dashboard.level1"/>", "scan0": level1vulnerabilityCounts[0][0], "scan1": level1vulnerabilityCounts[0][1], "scan2": level1vulnerabilityCounts[0][2]};
                } else if (scanCount2 === 4) {
                    values2[0] = {"name": "<spring:message code="listScans.dangandcrit"/>", "scan0": level4or5vulnerabilityCounts[0][0], "scan1": level4or5vulnerabilityCounts[0][1], "scan2": level4or5vulnerabilityCounts[0][2], "scan3": level4or5vulnerabilityCounts[0][3]};
                    values2[1] = {"name": "<spring:message code="dashboard.level3"/>", "scan0": level3vulnerabilityCounts[0][0], "scan1": level3vulnerabilityCounts[0][1], "scan2": level3vulnerabilityCounts[0][2], "scan3": level3vulnerabilityCounts[0][3]};
                    values2[2] = {"name": "<spring:message code="dashboard.level2"/>", "scan0": level2vulnerabilityCounts[0][0], "scan1": level2vulnerabilityCounts[0][1], "scan2": level2vulnerabilityCounts[0][2], "scan3": level2vulnerabilityCounts[0][3]};
                    values2[3] = {"name": "<spring:message code="dashboard.level1"/>", "scan0": level1vulnerabilityCounts[0][0], "scan1": level1vulnerabilityCounts[0][1], "scan2": level1vulnerabilityCounts[0][2], "scan3": level1vulnerabilityCounts[0][3]};
                }
                if (values2.length === 0) {
                    vulnerabilityCountsDiff.data = [];
                    vulnerabilityCountsDiffIndicator.show();
                } else {
                    $('#vulnerabilityCountsDiff').css("line-height", "");
                    vulnerabilityCountsDiff.data = values2;
                    vulnerabilityCountsDiffIndicator.hide();
                }

                var riskScoreDiffCounts = data.riskScoreDiffCounts;

                riskScoreDiff = am4core.create("riskScoreDiff", am4charts.XYChart);
                riskScoreDiff.data = [];
                var categoryAxis3 = riskScoreDiff.xAxes.push(new am4charts.CategoryAxis());
                categoryAxis3.dataFields.category = "name";
                categoryAxis3.renderer.grid.template.location = 0;
                var label3 = categoryAxis3.renderer.labels.template;
                label3.wrap = true;
                var valueAxis3 = riskScoreDiff.yAxes.push(new am4charts.ValueAxis());
                valueAxis3.renderer.inside = true;
                valueAxis3.renderer.labels.template.disabled = true;
                valueAxis3.min = 0;
                function createSeries3(field, name) {
                    var series = riskScoreDiff.series.push(new am4charts.ColumnSeries());
                    series.name = name;
                    series.dataFields.valueY = field;
                    series.dataFields.categoryX = "name";
                    series.sequencedInterpolation = true;
                    series.stroke = am4core.color("#ffffff");
                    series.stacked = true;
                    series.columns.template.width = am4core.percent(60);
                    series.columns.template.tooltipText = "[bold]{categoryX.id}[/]\n[font-size:14px]" + series.name + ": {valueY}";
                    var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                    labelBullet.label.text = "{valueY}";
                    labelBullet.locationY = 0.5;
                    series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                    return series;
                }
                var scanCount3 = 0;
                for (var i = 0; i < scans[0].length; i++) {
                    createSeries3("scan" + i, scans[0][i]);
                    scanCount3 += 1;
                }
                riskScoreDiffIndicator = riskScoreDiff.tooltipContainer.createChild(am4core.Container);
                riskScoreDiffIndicator.background.fill = am4core.color("#fff");
                riskScoreDiffIndicator.background.fillOpacity = 0.8;
                riskScoreDiffIndicator.width = am4core.percent(100);
                riskScoreDiffIndicator.height = am4core.percent(100);
                var riskScoreDiffIndicatorLabel = riskScoreDiff.createChild(am4core.Label);
                riskScoreDiffIndicatorLabel.text = "";
                riskScoreDiffIndicatorLabel.align = "center";
                riskScoreDiffIndicatorLabel.valign = "middle";
                riskScoreDiffIndicatorLabel.fontSize = 12;
                var values3 = [];
                if (scanCount3 === 2) {
                    values3[0] = {"name": "<spring:message code="listScans.TotalRiskScore"/>", "scan0": riskScoreDiffCounts[0][0], "scan1": riskScoreDiffCounts[0][1]};
                } else if (scanCount2 === 3) {
                    values3[0] = {"name": "<spring:message code="listScans.TotalRiskScore"/>", "scan0": riskScoreDiffCounts[0][0], "scan1": riskScoreDiffCounts[0][1], "scan2": riskScoreDiffCounts[0][2]};
                } else if (scanCount2 === 4) {
                    values3[0] = {"name": "<spring:message code="listScans.TotalRiskScore"/>", "scan0": riskScoreDiffCounts[0][0], "scan1": riskScoreDiffCounts[0][1], "scan2": riskScoreDiffCounts[0][2], "scan3": riskScoreDiffCounts[0][3]};
                }
                if (values3.length === 0) {
                    riskScoreDiff.data = [];
                    riskScoreDiffIndicator.show();
                } else {
                    $('#riskScoreDiff').css("line-height", "");
                    riskScoreDiff.data = values3;
                    riskScoreDiffIndicator.hide();
                }

            }

            var diffTable = "";
            var recreateDiff = false;
            function loadScanDiffTable() {
                recreateDiff = true;
                var scanIds = JSON.parse(differenceIds);
                if (scanIds !== null) {
                    if (scanIds.length === 2) {
                            diffTable = $("#scanDiffTable").dataTable({
                                "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                                filter: false,
                                processing: false,
                                scrollX: true,
                                paging: true,
                                aaSorting: [],
                                searching: false,
                                destroy: true,
                                serverSide: true,
                                ajax: {
                                "type": "POST",
                                "url": "loadScanDiff.json",
                                "data": function (d) {
                                    d.${_csrf.parameterName} = "${_csrf.token}",
                                    d.scan1 = JSON.parse(differenceIds)[0],
                                    d.scan2 = JSON.parse(differenceIds)[1],
                                    d.onlyDiff = document.getElementById("onlyDiff").checked;
                                },
                                "error": function (jqXHR, textStatus, errorThrown) {
                                    console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="listQualysScans.tableError"/>");
                                     $("#alertModal").modal("show");
                                    }
                                },
                                language: {
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
                                columns: [
                                    {"data": "name", "orderable": false},
                                    {"data": function (data, type, row) {
                                            if (data.secondScan !== 'true') {
                                                return '<i class="fas fa-times" aria-hidden="true"></i>';
                                            } else if (document.getElementById("onlyDiff").checked === false && data.firstScan === 'true' && data.secondScan === 'true') {
                                                var result = "";
                                                for (var i = 0; i < data.commonVulnSecondStatuses.length; i++) {
                                                    if (data.commonVulnSecondProtocols[i] != "-") {
                                                        result += "<div>" + riskScoreDiffView(data.commonVulnSecondRiskScores[i]) + data.commonVulnSecondIps[i] + ' (' + data.commonVulnSecondPorts[i] + ' (' + data.commonVulnSecondProtocols[i] + ')' + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + data.commonVulnSecondStatuses[i] + "</div>";
                                                    } else {
                                                        result += "<div>" + riskScoreDiffView(data.commonVulnSecondRiskScores[i]) + data.commonVulnSecondIps[i] + ' (' + data.commonVulnSecondPorts[i] + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + data.commonVulnSecondStatuses[i] + "</div>";
                                                    }

                                                    if (i != data.commonVulnSecondStatuses.length - 1) {
                                                        result += "<br>";
                                                    }
                                                }
                                                return result;
                                            } else {
                                                var statuses = data.statuses.split(",");
                                                var ips = data.ips.split(",");
                                                var ports = data.ports.split(",");
                                                var protocols = data.protocols.split(",");
                                                var riskScores = data.riskScores.split(",");
                                                var result = "";
                                                for (var i = 0; i < statuses.length; i++) {
                                                    if (data.protocols[i] != "-") {
                                                        result += "<div>" + riskScoreDiffView(riskScores[i]) + ips[i] + ' (' + ports[i] + ' (' + protocols[i] + ')' + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + statuses[i] + "</div>";
                                                    } else {
                                                        result += "<div>" + riskScoreDiffView(riskScores[i]) + ips[i] + ' (' + ports[i] + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + statuses[i] + "</div>";
                                                    }
                                                    if (i != statuses.length - 1) {
                                                        result += "<br>";
                                                    }
                                                }
                                                return result;
                                            }
                                        }, "orderable": false
                                    },
                                    {"data": function (data, type, row) {
                                            if (data.firstScan !== 'true') {
                                                return '<i class="fas fa-times" aria-hidden="true"></i>';
                                            } else if (document.getElementById("onlyDiff").checked === false && data.firstScan === 'true' && data.secondScan === 'true') {
                                                var result = "";
                                                for (var i = 0; i < data.commonVulnFirstStatuses.length; i++) {
                                                    if (data.commonVulnFirstProtocols[i] != "-") {
                                                        result += "<div>" + riskScoreDiffView(data.commonVulnFirstRiskScores[i]) + data.commonVulnFirstIps[i] + ' (' + data.commonVulnFirstPorts[i] + ' (' + data.commonVulnFirstProtocols[i] + ')' + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + data.commonVulnFirstStatuses[i] + "</div>";
                                                    } else {
                                                        result += "<div>" + riskScoreDiffView(data.commonVulnFirstRiskScores[i]) + data.commonVulnFirstIps[i] + ' (' + data.commonVulnFirstPorts[i] + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + data.commonVulnFirstStatuses[i] + "</div>";
                                                    }
                                                    if (i != data.commonVulnFirstStatuses.length - 1) {
                                                        result += "<br>";
                                                    }
                                                }
                                                return result;
                                            } else
                                                var statuses = data.statuses.split(",");
                                            var ips = data.ips.split(",");
                                            var ports = data.ports.split(",");
                                            var protocols = data.protocols.split(",");
                                            var riskScores = data.riskScores.split(",");
                                            var result = "";
                                            for (var i = 0; i < statuses.length; i++) {
                                                if (data.protocols[i] != "-") {
                                                    result += "<div>" + riskScoreDiffView(riskScores[i]) + ips[i] + ' (' + ports[i] + ' (' + protocols[i] + ')' + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + statuses[i] + "</div>";
                                                } else {
                                                    result += "<div>" + riskScoreDiffView(riskScores[i]) + ips[i] + ' (' + ports[i] + ')&nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>&nbsp;' + statuses[i] + "</div>";
                                                }
                                                if (i != statuses.length - 1) {
                                                    result += "<br>";
                                                }
                                            }
                                            return result;
                                        }, "orderable": false
                                    },
                                    {"data": "riskLevels", "orderable": false}
                                ],
                                createdRow: function (row, data, dataIndex) {
                                    if (data.firstScan == 'true' && data.secondScan != 'true') {
                                        $(row).css('background-color', '#FDEDEC');
                                    } else if (data.firstScan != 'true' && data.secondScan == 'true') {
                                        $(row).css('background-color', 'white');
                                    } else {
                                        $(row).css('background-color', '#EAF2F8');
                                    }
                                    var service = "3";
                                    switch (data.riskLevels.toString()) {
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
                                    $("#scan1").text(decodeHtml(data.firstScanName));
                                    $("#scan2").text(decodeHtml(data.secondScanName));
                                    $("#scanDiffTable_length").css('textAlign', 'left'); 
                                },
                                rowsGroup: [0,3]
                            });                     
                    }
                }
            }
            
            function riskScoreDiffView(score){
                var scoreInt = parseInt(score);
                if (scoreInt > 80) {
                    return '<div class="riskLevel5 riskLevelCommon" style="width:70px;float:left">' + scoreInt + '</div>';
                } else if (scoreInt > 60) {
                    return '<div class="riskLevel4 riskLevelCommon" style="width:70px;float:left">' + scoreInt + '</div>';
                } else if (scoreInt > 40) {
                    return '<div class="riskLevel3 riskLevelCommon" style="width:70px;float:left">' + scoreInt + '</div>';
                } else if (scoreInt > 20) {
                    return '<div class="riskLevel2 riskLevelCommon" style="width:70px;float:left">' + scoreInt + '</div>';
                } else if (scoreInt > 0) {
                    return '<div class="riskLevel1 riskLevelCommon" style="width:70px;float:left">' + scoreInt + '</div>';
                } else {
                    return '<div class="riskLevel0 riskLevelCommon" style="width:70px;float:left">' + scoreInt + '</div>';
                }
            }

            function archiveScans() {
                var scanIds2 = [];
                if (currentTab == 'first') {
                    $('[id=selectedScan]:checked').each(function () {
                        scanIds2.push($(this).val());
                    });
                    $.post("archiveScans.json", {
                        'scanIds2': scanIds2, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        oTable.fnDraw();
                    });
                }
            }
            function unarchiveScans() {
                var scanIds2 = [];
                if (currentTab == 'first') {
                    $('[id=selectedScan]:checked').each(function () {
                        scanIds2.push($(this).val());
                    });
                }
                $.post("unarchiveScans.json", {
                    'scanIds2': scanIds2, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function () {
                }).fail(function () {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                    $("#alertModal").modal("show");
                }).always(function () {
                    oTable.fnDraw();
                });
            }
            function deleteScans() {

                function confirmDelete() {
                    blockUILoading();
                    var scanIds2 = [];
                    switch (currentTab) {

                        case 'first':

                            $('[id=selectedScan]:checked').each(function () {
                                scanIds2.push($(this).val());
                            });
                            $.post("deleteScans.json", {
                                'scanIds2': scanIds2, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                            }).done(function () {
                            }).fail(function () {
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                                $("#alertModal").modal("show");
                            }).always(function () {
                                oTable.fnDraw();
                                unBlockUILoading();
                            });

                            break;
                        case 'second':

                            $('[id=selectedScanD]:checked').each(function () {
                                scanIds2.push($(this).val());
                            });
                            $.post("deleteScans.json", {
                                'scanIds2': scanIds2, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                            }).done(function () {
                            }).fail(function () {
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                                $("#alertModal").modal("show");
                            }).always(function () {
                                oTable2.fnDraw();
                                unBlockUILoading();
                            });

                            break;
                        case 'third':
                            $('[id=selectedScanP]:checked').each(function () {
                                scanIds2.push($(this).val());
                            });
                            $.post("deleteScheduledScans.json", {
                                'scanIds2': scanIds2, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                            }).done(function () {
                            }).fail(function () {
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                                $("#alertModal").modal("show");
                            }).always(function () {
                                oTable3.fnDraw();
                                unBlockUILoading();
                                localStorage.setItem("scanCreated", "listScheduled");
                                location.reload();
                            });


                            break;
                        default:

                    }
                }

                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listKBItems.confirmDelete"/>"), confirmDelete);
            }




            function copyScan(scanId) {

                function confirmCopy() {

                    blockUILoading();
                    $.post("copyScan.json", {
                        'scanId': scanId,
            ${_csrf.parameterName}: "${_csrf.token}"
                    }, function () {
                    }).done(function (data, textStatus, jqXHR) {
                        oTable.fnDraw();
                    }).fail(function () {
                        $('#actionModal').modal('hide');
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.copyScanFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        unBlockUILoading();
                    });
                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listScans.confirmCopyScan"/>"), confirmCopy);
            }

            var selectedScan = {};
            var xhr = new XMLHttpRequest();
            function openModal(param) {
                selectedScan = param;
                $('#state').val("false").trigger('change');
            }
            function reportNameControl() {
                var text = document.getElementById("reportName");

                if (!text.value || text.value.length === 0) {
                    document.getElementById("statusErrorPTag").style.visibility = "visible";
                    //return 'fail';
                } else {
                    document.getElementById("statusErrorPTag").style.visibility = "hidden";
                    redirectReport();
                    // return 'success';
                }
            }
            function closeReportTypeModal() {
                $('#reportName').val("");
                $('#reportType').val('<spring:message code="listVulnerabilities.pdf"/>');
                document.getElementById("reportExtension").innerHTML = '<b>.pdf</b>';
                $('#selectReportType').modal('hide');
            }
            
            $('#state').on('change', function(){
                statusGraphFunc();
                riskLevelGraphFunc();
                assetGraphFunc();
            });
            
            function statusGraphFunc(){
                document.getElementById("statusGraph").innerHTML = '';
                var parameters = {scan: selectedScan, state: $('#state').val(), ${_csrf.parameterName}: "${_csrf.token}"};
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
                            combined[7] = {"status": decodeHtml("<spring:message code="genericdb.passive"/>"), "color": '#2F4074', "value": temp[7]};
                            $('#statusGraph').css("line-height", "");
                            statusGraphFunction(combined);
                        },
                        "data": parameters,
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    });
            }
            
            function riskLevelGraphFunc(){
                document.getElementById("riskLevelGraph").innerHTML = '';
                var parameters = {scan: selectedScan, state: $('#state').val(), ${_csrf.parameterName}: "${_csrf.token}"};
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
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    });
            }
                    
            function assetGraphFunc(){
                document.getElementById("assetGraph").innerHTML = '';
                var parameters = {scan: selectedScan, state: $('#state').val(), ${_csrf.parameterName}: "${_csrf.token}"};
                    $.ajax({
                        "type": "POST",
                        "url": "loadAssetVulnerabilityCountGraph.json",
                        "success": function (result) {
                            var temp = result;
                            var combined = [];
                            for (var i = 0; i < temp.length; i++) {
                                combined[i] = {"asset": decodeHtml(temp[temp.length-i-1].ip), "color": '#F9FABB', "closedVulnerabilityCount": temp[temp.length-i-1].closedVulnerabilityCount, "level5": temp[temp.length-i-1].level5, "level4": temp[temp.length-i-1].level4, "level3": temp[temp.length-i-1].level3, "level2": temp[temp.length-i-1].level2, "level1": temp[temp.length-i-1].level1};
                            }
                            $('#assetGraph').css("line-height", "");
                            assetLevelGraphFunction(combined);
                        },
                        "data": parameters,
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    });
            }
                    
            function redirectReport() {
                var params = {scan: selectedScan, reportType: $('#reportType').val(), reportName: $('#reportName').val(), state: $('#state').val(),
                    statusGraphData: "", riskLevelGraphData: "", assetLevelGraphData:"", ${_csrf.parameterName}: "${_csrf.token}"};
                $('#scanDetails').modal('hide');
                if ($('#reportType').val() === '<spring:message code="listVulnerabilities.pdf"/>') {
                            blockUILoading();
                            riskLevelGraph.exporting.getImage("png").then(function (response) {
                                params["riskLevelGraphData"] = response;
                            });
                            statusGraph.exporting.getImage("png").then(function (response) {
                                params["statusGraphData"] = response;
                            });
                            assetLevelGraph.exporting.getImage("png").then(function (response) {
                                params["assetLevelGraphData"] = response;
                            });
                    setTimeout(function () {
                        generateReport("getScanReport.json", params, "<spring:message code="report.reportCreation"/>",
                                "<spring:message code="listVulnerabilities.reportError"/>","<spring:message code="listScans.noActiveData"/>");
                                unBlockUILoading();
                    }, 10000);
                } else {
                    generateReport("getScanReport.json", params, "<spring:message code="report.reportCreation"/>",
                            "<spring:message code="listVulnerabilities.reportError"/>","<spring:message code="listScans.noActiveData"/>");
                            unBlockUILoading();
                }
                closeReportTypeModal();
            }
            xhr.onloadend = function () {
                $("#startLoadingModal").unblock({message: null});
                App.stopPageLoading();
                $('#startLoadingModal').modal('hide');
            };
            function closeBddkReportModal() {
                $('#bddkReportName').val("");
                $('#bddkReport').modal('hide');
            }
            function bddkReportNameControl() {
                var text = document.getElementById("bddkReportName");

                if (!text.value || text.value.length === 0) {
                    document.getElementById("statusErrorBTag").style.visibility = "visible";
                    //return 'fail';
                } else {
                    document.getElementById("statusErrorBTag").style.visibility = "hidden";
                    getBDDKReport();
                    // return 'success';
                }
            }
            function getBDDKReport() {
                var params = {scan: selectedScan, reportName: $('#bddkReportName').val(), ${_csrf.parameterName}: "${_csrf.token}"};
                generateReport("getBDDKReport.json", params, "<spring:message code="report.reportCreation"/>",
                        "<spring:message code="listVulnerabilities.reportError"/>","<spring:message code="listScans.noActiveData"/>");
                closeBddkReportModal();
            }
            function openDetails(scanId, type) {
                $.post('getScanDetails.json', {
                    'scanId': scanId,
                    'type': type,
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (data) {
                    $('#scanNameDetails').text(decodeHtml(data.name));
                    $('#descDetails').text(decodeHtml(data.desc));
                    $('#sourceDetails').text(decodeHtml(data.src));
                    $('#reqbyDetails').text(decodeHtml(data.reqBy));
                    $('#reqdateDetails').text(data.reqDate);
                    if (data.active === "false")
                        $('#activeDetails').text("<spring:message code="genericdb.passive"/>");
                    else if (data.active === "true")
                        $('#activeDetails').text("<spring:message code="listScans.active"/>");
                    else
                        $('#activeDetails').text("");
                    $('#targetDetails').text(decodeHtml(data.targets));
                    $('#scandateDetails').text(data.scanDate);
                    $('#compdateDetails').text(data.compDate);
                    if (data.status === "Sıraya alındı")
                        $('#statusDetails').text("<spring:message code="ScanStatus.RUNNING"/>");
                    else if (data.status === "Başlatıldı")
                        $('#statusDetails').text("<spring:message code="ScanStatus.STARTED"/>");
                    else if (data.status === "Devam Ediyor")
                        $('#statusDetails').text("<spring:message code="ScanStatus.RUNNING"/>");
                    else if (data.status === "İptal Edildi")
                        $('#statusDetails').text("<spring:message code="ScanStatus.CANCELED"/>");
                    else if (data.status === "Duraklatıldı")
                        $('#statusDetails').text("<spring:message code="ScanStatus.PAUSED"/>");
                    else if (data.status === "Tamamlandı")
                        $('#statusDetails').text("<spring:message code="ScanStatus.FINISHED"/>");
                    else if (data.status === "Planlanan Tarama")
                        $('#statusDetails').text("<spring:message code="ScanStatus.SCHEDULED"/>");
                    else if (data.status === "Duraklatılıyor")
                        $('#statusDetails').text("<spring:message code="ScanStatus.PAUSING"/>");
                    else if (data.status === "Yükleniyor")
                        $('#statusDetails').text("<spring:message code="ScanStatus.LOADING"/>");
                    else if (data.status === "Sürdürülüyor")
                        $('#statusDetails').text("<spring:message code="ScanStatus.RESUMING"/>");
                    else if (data.status === "İptal ediliyor")
                        $('#statusDetails').text("<spring:message code="ScanStatus.CANCELING"/>");
                    else if (data.status === "Hata")
                        $('#statusDetails').text("<spring:message code="ScanStatus.ERROR"/>");
                    else if (data.status === "Tamamlandı")
                        $('#statusDetails').text("<spring:message code="ScanStatus.COMPLETED"/>");
                    else if (data.status === "Durum Bilgisi Yok")
                        $('#statusDetails').text("<spring:message code="ScanStatus.EMPTY"/>");
                    else if (data.status === "")
                        $('#statusDetails').text("<spring:message code="ScanStatus.IMPORTED"/>");
                    else if (data.status === "İptal Edildi")
                        $('#statusDetails').text("<spring:message code="ScanStatus.ABORTED"/>");
                    $('#policyDetails').text(decodeHtml(data.policy));
                    $('#scanDetails').modal('show');
                });
            }
            function startScanNow(scanId) {
                function confirmStartScanNow() {
                    blockUILoading();
                    $.post("startScheduledScanNow.json", {
                        'scanId': scanId,
            ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {
                        if (data.status === "success") {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.instantScanSucceeded"/>");
                            $("#alertModal").modal("show");
                        } else if (data.status === "failed") {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.errorInInstantScan"/>");
                            $("#alertModal").modal("show");
                        }
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.errorInInstantScan"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        oTable.api().ajax.reload();
                        oTable2.api().ajax.reload();
                        oTable3.api().ajax.reload();
                        unBlockUILoading();
                    });
                }
                jsInformationOkCancelModalFunction("<spring:message code="listScans.startScanNow"/>", confirmStartScanNow);
            }
            //Default checked

            $("#pentestScan").prop('checked', true);
            function showModal(scanId) {
                $.post('${pageContext.request.contextPath}/pentest/getScanAssetList.json', {
                    'scanId': scanId,
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (data) {
                    var table = document.getElementById("assetTable");
                    var body = document.createElement("tbody");
                    var tr1 = document.createElement("tr");
                    var td1 = document.createElement("td");
                    td1.innerHTML = '<spring:message code="addAsset.ip"/>';
                    var td2 = document.createElement("td");
                    td2.innerHTML = '<spring:message code="listAssets.hostname"/>';
                    tr1.appendChild(td1);
                    tr1.appendChild(td2);
                    body.appendChild(tr1);
                    for (var i = 0; i < data.length; i++) {
                        var tr = document.createElement("tr");
                        var td1 = document.createElement("td");
                        td1.innerHTML = data[i].scannedIp;
                        var td2 = document.createElement("td");
                        td2.innerHTML = data[i].hostname;
                        tr.appendChild(td1);
                        tr.appendChild(td2);
                        body.appendChild(tr);
                    }
                    table.appendChild(body);
                    $('#assetModal').modal('show');
                });
            }
            $('#assetModal').on("hidden.bs.modal", function () {
                $("#assetTable tbody").empty();
            });
            var temp = {};
            function addAssetToScanFunction(scanId) {
                temp = scanId;
                getCustomerAssets();
                getScanAssets();
            }
            function getScanAssets() {
                $("#removedAsset").select2({
                    multiple: true,
                    ajax: {
                        url: "${pageContext.request.contextPath}/pentest/getScanAssets.json",
                        dataType: 'json',
                        type: "post",
                        delay: 0,
                        data: function (params) {
                            var obj = {
                                scanId: temp,
                                scanAsset: params.term,
                                '${_csrf.parameterName}': "${_csrf.token}"
                            };
                            return obj;
                        },
                        processResults: function (data) {
                            var newResults = [];
                            $.each(data, function (index, item)
                            {
                                newResults.push({
                                    id: decodeHtml(item.id),
                                    text: decodeHtml(item.text)
                                });
                            });
                            return {
                                results: newResults
                            };
                        },
                        cache: true
                    },
                    minimumInputLength: 3,
                    language: {inputTooShort: function () {
                            return '<spring:message code="generic.selectMinChar"/>';
                        },
                        searching: function () {
                            return '<spring:message code="generic.selectSearching"/>';
                        },
                        noResults: function () {
                            return '<spring:message code="generic.selectNoResult"/>';
                        }
                    }
                });
            }
            function getCustomerAssets() {
                $("#addedAsset").select2({
                    tags: true,
                    multiple: true,
                    ajax: {
                        url: "${pageContext.request.contextPath}/pentest/getCustomerAssets.json",
                        dataType: 'json',
                        type: "post",
                        delay: 0,
                        data: function (params) {
                            var obj = {
                                scanAsset: params.term,
                                '${_csrf.parameterName}': "${_csrf.token}"
                            };
                            return obj;
                        },
                        processResults: function (data) {
                            var newResults = [];
                            $.each(data, function (index, item)
                            {
                                newResults.push({
                                    id: decodeHtml(item.id),
                                    text: decodeHtml(item.text)
                                });
                            });
                            return {
                                results: newResults
                            };
                        },
                        cache: true
                    },
                    minimumInputLength: 3,
                    language: {inputTooShort: function () {
                            return '<spring:message code="generic.selectMinChar"/>';
                        },
                        searching: function () {
                            return '<spring:message code="generic.selectSearching"/>';
                        }}
                });
            }
            $('#buttonback2').on('click', function () {
                $('#addAsset').hide();
                $('#sameAsset').hide();
                $('#vulnerabilityExist').hide();
            });
            $(function () {
                $('#addAssetToScan').on('submit', function (e) {
                    e.preventDefault();
                    $("#submit2").block({message: null});
                    App.startPageLoading({animate: true});
                    
                    var formData = new FormData();
                    if($('input[type=file]')[0].files[0] === undefined) {
                        formData.append('file', null); 
                    } else {
                        formData.append('file', $('input[type=file]')[0].files[0]); 
                    }
                    formData.append('ip', $('#addedAsset').val()); 
                    formData.append('removedIp', $('#removedAsset').val());
                    formData.append('selectedscan', temp);  
                      
                    $.ajax({
                            url: "addAssetToScan.json?${_csrf.parameterName}=${_csrf.token}",
                            method: "POST",
                            dataType: 'json',
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: function(data){
                                $("#submit2").unblock({message: null});
                                App.stopPageLoading();
                                if (data.check === 1) {
                                    if ($('#addedAsset').val() === null) {
                                    } else {
                                        $('#sameAsset').show();
                                        $('#sameAssets').html("<br>" + data.same.toString() + "</br>");
                                        if (data.different.length > 0) {
                                            $('#sameAssets').append("<br>" + "<spring:message code="listScans.differentAsset"/>" + "</br>");
                                            $('#sameAssets').append("<br>" + data.different.toString() + "</br>");
                                        }
                                    }
                                } else if (data.check === 2) {
                                    $('#vulnerabilityExist').show();
                                } else {
                                    $('#addAsset').modal('hide');
                                    $('#vulnerabilityExist').hide();
                                    oTable.fnDraw();
                                }
                                $("#addedAsset").val(null);
                                $("#removedAsset").val(null);
                                getScanAssets();
                            },
                            error: function(er){}
                    });
                });
            });
            $('#dateTimeScan').datetimepicker({
            });
            function displayScheduled(div, status) {
                if (status) {
                    document.getElementById(div).style.display = 'block';
                    $("#submit").hide();
                    $("#viewScan").show();
                } else {
                    document.getElementById(div).style.display = 'none';
                    $("#submit").show();
                    $("#viewScan").hide();
                }
            }

            //Tarama statuslerini ve tablolaro günceller.
            function refresh() {
                blockUILoading();
                $.post("refreshScanStatus.json", {${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function () {
                }).fail(function () {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listScans.refreshFail"/>");
                    $("#alertModal").modal("show");
                }).always(function () {
                    unBlockUILoading();
                    switch (currentTab) {
                        case 'first':
                            localStorage.setItem("scanCreated", "listCompleted");
                            break;
                        case 'second':
                            localStorage.setItem("scanCreated", "listRunning");
                            break;
                        case 'third':
                            localStorage.setItem("scanCreated", "listScheduled");
                            break;
                        default:
                            localStorage.setItem("scanCreated", "listCompleted");
                            break;
                    }
                });
            }
            function displayAutoScan(div, status) {
                if ($('#pentestScan').is(":checked")) {
                    document.getElementById("autoScan").style.display = 'none';
                } else {
                    document.getElementById("autoScan").style.display = 'block';
                }
            }

            function editScanName(scanId) {
                $('#editScanNameModal').modal();
                $("#selectedScanId").val(scanId);
            }

            function viewScanFunction() {
                var inputDate = $('#dateInput').val();
                if (inputDate === "") {
                    var now = new Date();
                    inputDate = formatDate(now);
                }
                var date = inputDate.substring(0, 10);
                var hour = inputDate.substring(11, inputDate.length);
                var splitDate = date.split("-");
                var splitHour = hour.split(":");
                var d = new Date(splitDate[0], splitDate[1] - 1, splitDate[2]);
                d.setHours(splitHour[0], splitHour[1], 0);
                var occurence = $('#occurence').val();
                var reccurence = $('#reccurence').val();
                if ($('#reccurence').val() === null || $('#reccurence').val() === "" || $('#reccurence').val() <= 0) {
                    reccurence = 101;
                }
                var resultList = [];
                resultList.push(d);
                if (occurence === "DAILY") {
                    for (var z = 1; z < reccurence; z++) {
                        var tomorrow = new Date(resultList[z - 1]);
                        tomorrow.setDate(tomorrow.getDate() + 1);
                        resultList.push(tomorrow);
                        if (resultList.length > 100) {
                            break;
                        }
                    }
                }
                if (occurence === "WEEKLY") {
                    for (var z = 1; z < reccurence; z++) {
                        var tomorrow = new Date(resultList[z - 1]);
                        tomorrow.setDate(tomorrow.getDate() + 7);
                        resultList.push(tomorrow);
                        if (resultList.length > 100) {
                            break;
                        }
                    }
                }
                if (occurence === "MONTHLY") {
                    for (var z = 1; z < reccurence; z++) {
                        var tomorrow = new Date(resultList[z - 1]);
                        tomorrow.setDate(tomorrow.getDate() + 30);
                        resultList.push(tomorrow);
                        if (resultList.length > 100) {
                            break;
                        }
                    }
                }
                if (occurence === "YEARLY") {
                    for (var z = 1; z < reccurence; z++) {
                        var tomorrow = new Date(resultList[z - 1]);
                        tomorrow.setDate(tomorrow.getDate() + 365);
                        resultList.push(tomorrow);
                        if (resultList.length > 100) {
                            break;
                        }
                    }
                }
                var finalResult = "";
                for (var c = 0; c < resultList.length; c++) {
                    var x = resultList[c].toLocaleString();
                    finalResult = finalResult + x.substring(0, x.length - 3) + "<br>";
                }
                if (resultList.length == 101) {
                    finalResult += "...";
                }
                $('#info').html(finalResult);
                $('#infoScreen').modal('show');
            }
            $('#start').on('click', function () {
                $('#submit').trigger('click');
                $('#infoScreen').modal('hide');
                activeTab('tab3default');
            });
            function formatDate(date) {
                var d = new Date(date),
                        month = '' + (d.getMonth() + 1),
                        day = '' + d.getDate(),
                        year = d.getFullYear();
                hour = d.getHours();
                minute = d.getMinutes();
                if (month.length < 2)
                    month = '0' + month;
                if (day.length < 2)
                    day = '0' + day;
                return [year, month, day].join('-') + " " + [hour, minute].join(':');
            }

            $('#reccurence').val(1);
            $('#reccurence').attr("disabled", "disabled");
            $('#occurence').on('change', function () {
                if ($('#occurence').val() === "ON_DEMAND") {
                    $('#reccurence').val(1);
                    $('#reccurence').attr("disabled", "disabled");
                } else {
                    $('#reccurence').val("");
                    $('#reccurence').removeAttr("disabled");
                }
            });
            function rescanFunction(scanId)
            {
                $('#rescanModal').modal("show");
                $('#oldScanId').val(scanId);
            }

            function submitRescan()
            {
                $.ajax({
                    "url": "rescan.json",
                    "type": "POST",
                    "data": {
                        '${_csrf.parameterName}': "${_csrf.token}",
                        'oldScan': $('#oldScanId').val(),
                        'newScan': $('#newScanName').val()
                    },
                    "success": function (data) {
                        if (data.error == "same")
                        {
                            $("#rescanError").html("<spring:message code="listScans.rescanSameName"/>");
                            $("#rescanModal").modal("show");
                            document.getElementById("rescanError").style.visibility = "visible";
                            return;
                        }
                        if (data.error == "empty")
                        {
                            $("#rescanError").html("<spring:message code="listScans.rescanEmpty"/>");
                            $("#rescanModal").modal("show");
                            document.getElementById("rescanError").style.visibility = "visible";
                            return;
                        }
                        if (data.error == "nullServer")
                        {
                            $("#rescanError").html("<spring:message code="listScans.rescanServerError"/>");
                            $("#rescanModal").modal("show");
                            document.getElementById("rescanError").style.visibility = "visible";
                            return;
                        }
                        closeRescanModal();
                        oTable2.fnDraw();
                    },
                    error: function (jqXHR, status, error) {
                        console.log(status + ": " + error);
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.errorMessage"/>");
                        $("#alertModal").modal("show");
                    }
                });
            }

            function closeRescanModal()
            {
                $("#rescanModal").removeClass("in");
                $(".modal-backdrop").remove();
                $('body').removeClass('modal-open');
                $('body').css('padding-right', '');
                $("#rescanModal").hide();
                $("#newScanName").val('');
            }
            function showChooseModal(scanId)
            {
                $('#chooseModal').modal("show");
                $('#rescanButton').click(function ()
                {
                    $('#chooseModal').hide();
                    rescanFunction(scanId);
                });
                $('#copyButton').click(function ()
                {
                    $('#chooseModal').hide();
                    copyScan(scanId);
                });
            }

            var scanIdGeneric = {};
            function exportPentestScan(scanId) {
                scanIdGeneric = scanId;
                $("#exportAssetFilter").select2({
                    multiple: true,
                    ajax: {
                        url: "${pageContext.request.contextPath}/pentest/getScanAssets.json",
                        dataType: 'json',
                        type: "post",
                        delay: 0,
                        data: function (params) {
                            var obj = {
                                scanId: scanId,
                                scanAsset: params.term,
                                '${_csrf.parameterName}': "${_csrf.token}"
                            };
                            return obj;
                        },
                        processResults: function (data) {
                            var newResults = [];
                            $.each(data, function (index, item)
                            {
                                newResults.push({
                                    id: decodeHtml(item.id),
                                    text: decodeHtml(item.text)
                                });
                            });
                            return {
                                results: newResults
                            };
                        },
                        cache: true
                    },
                    minimumInputLength: 3,
                    language: {inputTooShort: function () {
                            return '<spring:message code="generic.selectMinChar"/>';
                        },
                        searching: function () {
                            return '<spring:message code="generic.selectSearching"/>';
                        },
                        noResults: function () {
                            return '<spring:message code="generic.selectNoResult"/>';
                        }
                    }
                });
                $('#exportFilter').modal("show");
            }
            
            function exportFilterConfirm() {
                var assetFilter = $('#exportAssetFilter').select2('data');
                var filterString = "";
                for(var i=0;i < assetFilter.length ; i++){
                    filterString += assetFilter[i].id + ",";
                };
                var url = 'exportPentestResult.htm?scanId=' + scanIdGeneric + '&assetFilter=' + filterString;
                window.location.href = encodeURI(url);
                $('#exportFilter').modal("hide");
            }

            $('#sourceFilter').on('change', function () {
                oTable.api().ajax.reload();
            });
            $('#sourceFilter2').on('change', function () {
                oTable2.api().ajax.reload();
            });
            $('#sourceFilter3').on('change', function () {
                oTable3.api().ajax.reload();
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
        </script>
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />

        <style>
            .progress {
                background-color: grey !important;
            }
            .pre {
                white-space: pre-wrap;
            }
            .ui-autocomplete {
                position: absolute;
                z-index: 10100 !important;
                max-height: 300px;
                overflow-y: auto;
                /* prevent horizontal scrollbar */
                overflow-x: hidden;
            }
            /* IE 6 doesn't support max-height
            * we use height instead, but this forces the menu to always be this tall
            */
            * html .ui-autocomplete {
                height: 100px;
            }
            .popover .arrow {
                display: none;
            }
            [id^="product"] {
                padding-top: 0px;
            }
            .dt-buttons {
                margin-left: 5px; 
                margin-top: 0px !important;
                float: none !important;
                display: inline;
            }
            div.dataTables_wrapper div.dataTables_filter {
                text-align: left;
                display: inline;
            }
            .dataTables_length {
                text-align: right;
            }
            #completedScanTable_processing
           {
            margin-top: -1.5%;      
            z-index: 1200;              
           }
           #runningScanTable_processing
           {
            margin-top: -1.5%;      
            z-index: 1200;              
           }
           #scheduledScanTable_processing
           {
            margin-top: -1.5%;      
            z-index: 1200;              
           }
            
            
        </style>

    </jsp:attribute>

    <jsp:body>
        <div class="modal fade" id="startLoadingModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        </div>     

        
                             
                <!-- /.panel-heading -->
                <div class="portlet-body">
                    <div>
                        <div class="panel with-nav-tabs panel-default">
                            <div class="tabbable-custom nav justified">
                                <ul class="nav nav-tabs nav-justified">
                                    <li class="active" ><a  style="text-decoration:none;color:#428bca" href="#tab1default" data-toggle="tab"><div id="tabCompletedHeader"></div></a></li>
                                    <li><a  style="text-decoration:none;color:#428bca" href="#tab2default" data-toggle="tab"><div id="tabRunningHeader"></div></a></li>
                                    <li><a  style="text-decoration:none;color:#428bca" href="#tab3default" data-toggle="tab"><div id="tabScheduledHeader"></div></a></li>
                                </ul>
                            </div>
                            <div class="panel-body">      
                               
                                <div class="tab-content">
                                    <div class="tab-pane fade in active" id="tab1default">      
                                            <table  width="100%" class="table table-striped table-bordered table-hover" id="completedScanTable" style="width: 100%;">
                                                <thead id="completedScanTableThead" class="datatablesThead">
                                                    <tr>
                                                        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN,ROLE_COMPANY_MANAGER_READONLY,ROLE_PENTEST_USER')">
                                                            <th style="vertical-align: middle;text-align: center"><input type="checkbox"  class="editor-active" id="selectAll" onclick="selectAll('selectedScan');" ></th>
                                                        </sec:authorize>
                                                    <th style="vertical-align: middle; min-width: 150px;"><spring:message code="listScans.name"/></th> 
                                                    <th style="vertical-align: middle; min-width: 50px;"><spring:message code="listScans.status"/></th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.scanDate"/></th>
                                                    <th style="vertical-align: middle;"><spring:message code="listScans.target"/></th>
                                                    <th style="vertical-align: middle;"><spring:message code="listScans.excludeIps"/></th>
                                                    <th style="vertical-align: middle; min-width: 50px;" width="50px" ><spring:message code="listScans.vulnCount"/></th>
                                                    <th style="vertical-align: middle; min-width: 50px;" width="50px" ><spring:message code="listAssetGroups.assetsCount"/></th>
                                                    <th style="vertical-align: middle; min-width: 100px;" width="100px" >
                                                    <div class="form-group" style="margin-top: 10px">
                                                        <select id ="sourceFilter" name="sourceFilter" class="js-example-basic-multiple js-states form-control" >
                                                            <option value=all selected><spring:message code="listScans.source"/></option>
                                                            <c:forEach var="existingSource" items="${existingSources}">
                                                                <option value='<c:out value="${existingSource.source}"/>'><c:out value="${existingSource.source}"/></option> 
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    </th>
                                                    <th style="vertical-align: middle; min-width: 90px;" width="90px"> <spring:message code="listScans.policy"/>    </th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.requestDate"/></th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.completionDate"/></th>
                                                    <th style="min-width: 100px; width: 100px;" class="sorting_disabled" rowspan="1" colspan="1" aria-label=" "> </th>

                                                    </tr>
                                                    </thead>                                
                                            </table>
                                    </div>
                                    <div class="tab-pane fade" id="tab2default">
                                        <div>
                                            <table class="table table-striped table-bordered table-hover" id="runningScanTable" style="width:100%;">
                                                <thead id="runningScanTableThead" style="width: 100%;" class="datatablesThead">
                                                    <tr>
                                                        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER_READONLY,ROLE_PENTEST_USER')">
                                                           <th style="vertical-align: middle;text-align: center"><input type="checkbox" class="editor-active" id="selectAll2" onclick="selectAll2('selectAll2', 'selectedScanD');" ></th>
                                                        </sec:authorize>
                                                    <th style="vertical-align: middle; min-width: 150px;"><spring:message code="listScans.name"/></th> 
                                                    <th style="vertical-align: middle; min-width: 50px;"><spring:message code="listScans.status"/></th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.scanDate"/></th>
                                                    <th style="vertical-align: middle; min-width: 240px; "><spring:message code="listScans.target"/></th>
                                                    <th style="vertical-align: middle;"><spring:message code="listScans.excludeIps"/></th>
                                                    <th style="vertical-align: middle; min-width: 100px;" width="100px">
                                                    <div class="form-group" style="margin-top: 10px">
                                                        <select id ="sourceFilter2" name="sourceFilter2" class="js-example-basic-multiple js-states form-control" >
                                                            <option value=all selected><spring:message code="listScans.source"/></option>
                                                            <c:forEach var="existingSource" items="${existingSources}">
                                                                <option value='<c:out value="${existingSource.source}"/>'><c:out value="${existingSource.source}"/></option> 
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    </th>
                                                    <th style="vertical-align: middle; min-width: 90px;" width="90px"> <spring:message code="listScans.policy"/>    </th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.requestDate"/></th>
                                                    <th style="min-width: 200px; width: 200px;" width="200px" class="sorting_disabled" rowspan="1" colspan="1" aria-label=" "> </th>

                                                    </tr>
                                                    </thead>                                
                                            </table>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="tab3default">
                                        <div>
                                            <table class="table table-striped table-bordered table-hover" id="scheduledScanTable" style="width: 100% !important;">
                                                <thead id="scheduledScanTableThead" style="width: 100%;" class="datatablesThead">
                                                    <tr>
                                                        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER,ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER_READONLY,ROLE_PENTEST_USER')">
                                                            <th style="vertical-align: middle;text-align: center"><input type="checkbox" class="editor-active" id="selectAll3" onclick="selectAll2('selectAll3', 'selectedScanP');" ></th>
                                                        </sec:authorize>
                                                    <th style="vertical-align: middle; min-width: 150px;"><spring:message code="listScans.name"/></th> 
                                                    <th style="vertical-align: middle; min-width: 100px;"><spring:message code="listScans.status"/></th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.previousScanDate"/></th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.nextScanDate"/></th>
                                                    <th style="vertical-align: middle;"><spring:message code="listScans.completedScanCount"/></th>
                                                    <th style="vertical-align: middle; min-width: 50px;" width="50px" ><spring:message code="listScans.remainingScan"/></th>
                                                    <th style="vertical-align: middle; min-width: 50px;" width="50px" ><spring:message code="startQualysScan.recurrence"/></th>
                                                    <th style="vertical-align: middle; min-width: 50px;" width="50px" ><spring:message code="startQualysScan.frequency"/></th>
                                                    <th style="vertical-align: middle; min-width: 240px; "><spring:message code="listScans.target"/></th>     
                                                    <th style="vertical-align: middle; min-width: 100px;" width="100px">
                                                    <div class="form-group" style="margin-top: 10px">
                                                        <select id ="sourceFilter3" name="sourceFilter3" class="js-example-basic-multiple js-states form-control" >
                                                            <option value=all selected><spring:message code="listScans.source"/></option>
                                                            <c:forEach var="existingSource" items="${existingSources}">
                                                                <option value='<c:out value="${existingSource.source}"/>'><c:out value="${existingSource.source}"/></option> 
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    </th>
                                                    <th style="vertical-align: middle; min-width: 90px;" width="90px"> <spring:message code="listScans.policy"/>    </th>
                                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.requestDate"/></th>
                                                    <th style="min-width: 200px; width: 200px;" width="200px" class="sorting_disabled" rowspan="1" colspan="1" aria-label=" "> </th>

                                                    </tr>
                                                    </thead>                                
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="alert alert-danger" id="warningRowUpdate" style="display:none">
                        <spring:message code="logTrace.tableUpdate.error"/>
                    </div> 

                    <div class="alert alert-danger" id="warningRowRefresh" style="display:none">
                        <spring:message code="logTrace.refresh.error"/>
                    </div>
                    <!-- /.table-responsive -->          
                </div>
                <!-- /.panel-body -->
                <!-- /.panel -->
           
            <!-- /.col-lg-12 -->
        

        <div class="row">
            <jsp:include page="include/editScanNameModal.jsp" >
                <jsp:param name="type" value="vulnerability"/>  
            </jsp:include>
            <div class="modal fade" id="addAsset" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <spring:message code="listAssetGroups.addAsset"/> / <spring:message code="multiVulnerabilityParametersChangeModal.remove"/>
                        </div>
                        <form:form commandName="asset" class="form-horizontal" role="form" id="addAssetToScan" method="POST" autocomplete="off" enctype="multipart/form-data">
                            <div class="modal-body">                       
                                <div class="panel-body"> 
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="form-group">
                                                <input type="checkbox" id="fileImportAdd"/><label for="fileImportAdd"><spring:message code="import.csv"/></label> <br/>
                                                <div id="addAssetText" style="display:block;">
                                                    <label><spring:message code="listAssetGroups.addAsset"/></label>
                                                    <select class="js-example-tags form-control" style="width: 100%;" id="addedAsset" name="addedAsset">
                                                    </select>
                                                    <span class="error"><p id="assetError"></p></span>
                                                </div>
                                                <div id="addAssetFile" style="display:none;">
                                                    <label for="file" class="custom-file-upload">
                                                        <i class="fas fa-upload"></i> <spring:message code="importFromNessusOutput.selectFile"/>
                                                    </label>
                                                    <input id="file" name="file" type="file"/>
                                                </div>    
                                            </div>

                                        </div>

                                    </div>
                                    <div id="sameAsset" class="alert alert-warning" style="display:none">
                                        <spring:message code="listScans.sameAsset"/>
                                        <div id="sameAssets"></div>
                                    </div>
                                    <hr>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="form-group">
                                                <label><spring:message code="listScans.removeAsset"/></label>
                                                <select class="js-example-tags form-control" style="width: 100%;" id="removedAsset" name="removedAsset">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="vulnerabilityExist" class="alert alert-warning" style="display:none">
                                        <spring:message code="listScans.vulnerabilityExist"/>
                                    </div>
                                    <div class="modal-footer" id="back-Submit">
                                        <div class="row">
                                            <div class="row">
                                                <button type="buttonback" id="buttonback2" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                                <button type="submit" id="submit2" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form:form>
                    </div>       
                </div>  
            </div>
            <div class="modal fade" id="rescanModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
                <div class="modal-dialog" style="height: 100%; overflow-x: hidden; width: 50%;"> 
                    <div class="modal-content">
                        <div class="modal-header">
                            <div id = "modal-header"><spring:message code="listScans.rescan"/></div>
                        </div>

                        <div id="modalBody">

                            <div class="col-lg-12">
                                <div class="row" style="padding-top: 10px;"></div>
                                <form id="rescanForm" method="POST" action="/pentest/rescan.json" onsubmit="return false;">
                                    <div class="form-group required ">
                                        <p>
                                            <label><spring:message code="listScans.rescanName"/></label>
                                        <input class="form-control" id="newScanName" style="margin-bottom: 1em;" title="*Gerekli" type="text" data-rule-required="true" required>
                                            <input type="hidden" id="oldScanId"/>
                                            </p>
                                    </div>

                                </form>
                                <div class="row" style="padding-top: 10px;"></div>
                                <div>
                                    <p id="rescanError" style="color:red;visibility:hidden"></p>
                                </div>
                            </div>
                            <div class="modal-footer"> 
                                <br>
                                <button type="button" id="submitForm" onclick="submitRescan()" class="btn btn-success success" data-dismiss="modal"><spring:message code="listScans.rescanStart"/></button> 
                                <button type="button" class="btn btn-default" onclick="closeRescanModal()" data-dismiss="modal"><spring:message code="listTags.cancel"/></button> 
                            </div>
                        </div> 
                    </div> 
                </div>
            </div>
            <div class="modal fade" id="assetModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
                <div class="modal-dialog" style="height: 90%; overflow-x: hidden; width: 50%;"> 
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"><spring:message code="listScans.target"/></h4>
                        </div>
                        <div id="modalBody">
                            <div id="detailAsset">
                                <div class="col-lg-12">
                                    <table width="100%" id="assetTable" class="table table-striped table-bordered table-hover" style="width: 100%; margin-top: 1%;">                            
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer"> 
                                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.close"/></button> 
                            </div> 
                        </div> 
                    </div> 
                </div>
            </div>
            <!--
            <div class="modal fade" id="chooseModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
                <div class="modal-dialog" style="height: 100%; overflow-x: hidden; width: 50%;"> 
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" style="width: 50%; float: left;" id="rescanButton"  class="btn btn-warning" data-dismiss="modal"><spring:message code="listScans.rescan"/></button> 
                            <button id = "copyButton" type="button" style="width: 50%;" class="btn btn-danger"  data-dismiss="modal"><spring:message code="listScans.copy"/></button>
                            <input type="hidden" id="oldScanId"/>

                        </div> 
                    </div> 
                </div>
            </div>
            -->
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
                                    <label><spring:message code="listVulnerabilities.reportType"/></label>
                                    <select id="reportType" data-style="btn-primary btn-sm" class="selectpicker btn btn-sm btn-info dropdown-toggle" onchange="reportTypeChanged();" data-style="btn btn-info btn-sm">
                                        <option value='<spring:message code="listVulnerabilities.pdf"/>'><spring:message code="listVulnerabilities.pdf"/></option>
                                        <option value='<spring:message code="listVulnerabilities.html"/>'><spring:message code="listVulnerabilities.html"/></option>
                                        <option value='<spring:message code="listVulnerabilities.csv"/>'><spring:message code="listVulnerabilities.csv"/></option>
                                        <option value='<spring:message code="listVulnerabilities.word"/>'><spring:message code="listVulnerabilities.word"/></option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><spring:message code="listVulnerabilities.reportStatus"/></label>
                                    <select id ="state" name="state" class="js-example-basic-multiple js-states form-control" >
                                        <option value=false><spring:message code="listScans.active"/> + <spring:message code="genericdb.passive"/></option>
                                        <option value=true><spring:message code="listScans.active"/></option>
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
            <div class="modal fade" id="bddkReport" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog" style="width:25%">
                    <div class="modal-content">
                        <div class="modal-header">
                            <spring:message code="listScans.bddkReport"/>
                        </div>
                        <div class="modal-body">                       
                            <div class="panel-body"> 
                                <div class="form-group required">
                                    <label><spring:message code="reviewReport.reportName"/></label>
                                    <div style="display:flex;">
                                        <input class="form-control" id ="bddkReportName" maxlength="50" style="width:80%;">
                                            <span id ="bddkReportExtension" style="width:20%;line-height:3;margin-left:2px;"><b>.docx</b></span>   
                                    </div>
                                </div>
                                <div class="form-group">
                                    <p id="statusErrorBTag" style="color:red;visibility:hidden">
                                        <br><b><spring:message code="report.reportNameValidation"/></b></p>        
                                </div>    
                                <br>
                                <div class="modal-footer" id="download">
                                    <div class="row">
                                        <div class="row">
                                            <button type="buttonback" id="buttonback4" onclick="closeBddkReportModal();" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                            <button onClick="bddkReportNameControl()" id="downloadBddkReport" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>       
                    </div>  
                </div>
            </div>
            <div class="modal fade" id="exportFilter" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog" style="width:25%">
                    <div class="modal-content">
                        <div class="modal-header">
                            <spring:message code="listScans.exportFilter"/>
                        </div>
                        <div class="modal-body">                       
                            <div class="panel-body"> 
                                <div class="form-group required">
                                    <label><spring:message code="addAsset.ip"/></label>
                                    <div style="display:flex;">
                                        <select class="js-example-tags form-control" style="width: 100%;" id="exportAssetFilter" name="exportAssetFilter">
                                        </select>
                                    </div>
                                </div>   
                                <br>
                                <div class="modal-footer" id="download">
                                    <div class="row">
                                        <div class="row">
                                            <button type="buttonback" id="buttonback5" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                            <button onClick="exportFilterConfirm()" id="exportFilterConfirm" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>       
                    </div>  
                </div>
            </div>
            <div class="modal fade" id="scanDetails" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog" style="width:65%">
                    <div class="modal-content">
                        <div class="modal-header">
                            <spring:message code="listScans.scanDetails"/>
                        </div>
                        <div class="modal-body">                       
                            <div id="detailVuln">
                                <div class="col-lg-12">
                                    <table width="100%" class="table table-striped table-bordered table-hover" style="width: 100%; margin-top: 1%; table-layout: fixed;">
                                        <tr>
                                            <th colspan="3"><b> <spring:message code="listScans.name"/> </b></th>
                                            <th width="20%"> <spring:message code="listScans.status"/> </th>
                                        </tr>
                                        <tr>
                                            <td colspan="3" id="scanNameDetails"></td>
                                            <td width="20%" id="statusDetails" ></td>
                                        </tr>
                                        <tr>
                                            <th colspan="2"><spring:message code="listScans.description"/></th>
                                            <th><spring:message code="listScans.requestedBy"/></th>
                                            <th><spring:message code="listScans.requestDate"/></th>
                                        </tr>
                                        <tr>
                                            <td colspan="2" id="descDetails" ></td>
                                            <td width="20%" id="reqbyDetails" ></td>
                                            <td width="20%" id="reqdateDetails" ></td>
                                        </tr>
                                        <tr>
                                            <th colspan="2" id="labelsHeader"><spring:message code="listScans.scanDate"/></th>
                                            <th colspan="2" id="cveListHeader"><spring:message code="listScans.completionDate"/></th>
                                        </tr>
                                        <tr>
                                            <td colspan="2" id="scandateDetails"></td>
                                            <td colspan="2" id="compdateDetails"></td>
                                        </tr>
                                        <tr>
                                            <th colspan="4"><spring:message code="listScans.target"/></th>
                                        </tr>
                                        <tr>
                                            <td colspan="4" id="targetDetails" style="height: 100px; overflow-x: scroll; overflow-y: scroll;"></td>
                                        </tr>                                     
                                        <tr>
                                            <th colspan="1"><spring:message code="listScans.source"/></th>
                                            <th colspan="2"><spring:message code="listScans.policy"/></th>
                                            <th colspan="1"><spring:message code="listScans.isActive"/></th>
                                        </tr>
                                        <tr>
                                            <td colspan="1" id="sourceDetails" ></td>
                                            <td colspan="2" id="policyDetails" ></td>
                                            <td colspan="1" id="activeDetails" ></td>
                                        </tr>                                    
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer"> 
                                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.close"/></button> 
                            </div>
                        </div>  
                    </div>
                </div>
            </div>
            <div class="modal fade" id="errorReport" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog" style="width:25%">
                    <div class="modal-content">
                        <div class="modal-body">                       
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <label><spring:message code="listScans.errorReport"/></label>
                                        </div>
                                        <div id="info"></div>
                                        <br>
                                    </div>
                                </div>
                                <div class="modal-footer" id="back_Submit">
                                    <div class="row">
                                        <div class="row">
                                            <button type="buttonback" id="cancel" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.close"/></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>           
            <div class="modal fade" id="infoScreen" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <spring:message code="listScans.preview"/>
                        </div>
                        <div class="modal-body">                       
                            <div class="panel-body"> 
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <label><spring:message code="listScans.scheduledInfo"/></label>
                                        </div>
                                        <div id="info"></div>
                                        <br>
                                    </div>
                                </div>
                                <div class="modal-footer" id="back_Submit">
                                    <div class="row">
                                        <div class="row">
                                            <button type="buttonback" id="cancel" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                            <button type="submit" id="start" class="btn btn-success success"><spring:message code="listScans.rescanStart"/></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>       
                </div>  
            </div>

            <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">  
                <div class="modal fade" id="diffTableModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content col-lg-12" style="width: 200%;margin-left: -50%">
                            <div class="modal-header">
                                <b><spring:message code="listScans.diffScans"/></b>
                            </div>
                            <div class="modal-body">
                                <div id="diffTable" class="col-lg-12">
                                    <div class="form-group">
                                        <input type="checkbox" class="editor-active" id="onlyDiff" onclick="onlyDiffFunction();"/>
                                        <label><spring:message code="listScans.showOnlyDiff"/></label>
                                    </div>
                                    <div class="col-lg-12">
                                        <table class="table table-striped table-bordered table-hover" id="scanDiffTable" style="width: 100% !important;">
                                            <thead id="scanDiffTableThead" class="datatablesThead">
                                                <tr>
                                                    <th style="vertical-align: middle" class="col-lg-3"><spring:message code="listVulnerabilities.vName"/></th>  
                                                    <th id= "scan2" style="vertical-align: middle" class="col-lg-4">Tarama 2</th>
                                                    <th id= "scan1" style="vertical-align: middle" class="col-lg-4">Tarama 1</th>
                                                    <th style="vertical-align: middle" class="col-lg-1"><spring:message code="listVulnerabilities.riskLevel"/></th> 
                                                </tr>
                                            </thead>                                
                                        </table>
                                        <br>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="diffGraphModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content col-lg-12" style="width: 200%;margin-left: -50%">
                            <div class="modal-header">
                                <b></b>
                            </div>
                            <div class="modal-body">
                                <div id="" class="col-lg-12">
                                    <div class="col-lg-6" id="graph">
                                        <div class="portlet light bordered shadow-soft">
                                            <div style="text-align: center" class="portlet-title">
                                                <div class="caption">
                                                    <i class="icon-equalizer font-dark hide"></i>
                                                    <span class="caption-subject font-dark bold uppercase"> 
                                                        <i class="far fa-chart-bar"></i> <spring:message code="listScans.asset"/>
                                                    </span>
                                                </div>                                
                                            </div>
                                            <div class="portlet-body" >
                                                <div id="assetCountsDiff" style="width: 100%;height: 400px"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="portlet light bordered shadow-soft">
                                            <div style="text-align: center" class="portlet-title">
                                                <div class="caption">
                                                    <i class="icon-equalizer font-dark hide"></i>
                                                    <span class="caption-subject font-dark bold uppercase"> 
                                                        <i class="far fa-chart-bar"></i> <spring:message code="listScans.vulnlevel"/>
                                                    </span>
                                                </div>                                
                                            </div>
                                            <div class="portlet-body" >
                                                <div id="vulnerabilityCountsDiff" style="width: 100%;height: 400px"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3"></div>
                                    <div class="col-lg-6">
                                        <div class="portlet light bordered shadow-soft">
                                            <div style="text-align: center" class="portlet-title">
                                                <div class="caption">
                                                    <i class="icon-equalizer font-dark hide"></i>
                                                    <span class="caption-subject font-dark bold uppercase"> 
                                                        <i class="far fa-chart-bar"></i> <spring:message code="listScans.riskScoreCompare"/>
                                                    </span>
                                                </div>                                
                                            </div>
                                            <div class="portlet-body" >
                                                <div id="riskScoreDiff" style="width: 100%;height: 400px"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </sec:authorize>
        </div>

    </jsp:body>

</biznet:mainPanel>

