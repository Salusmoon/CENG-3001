<%-- 
    Document   : listHostScans
    Created on : 07-Aug-2017, 15:00:04
    Author     : adem.dilbaz
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<biznet:mainPanel viewParams="title,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li><li>
                <a class="title" href="../customer/listAssets.htm"><spring:message code="listAssets.title"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="main.theme.hostScan"/></span>
            </li>
        </ul>
    </jsp:attribute>



    <jsp:attribute name="button">
        <p>
            <a class="btn btn-primary btn-sm" id="startScanBtn">
                <spring:message code="listScans.startScan"/>
            </a>
            <button onClick="deleteScans()" name="delete" type="button" class="btn btn-danger btn-sm"><spring:message code="listAssets.delete"/></button>
            <a><button onClick="refresh()" type="button" class="btn btn-info btn-sm refreshButton" data-toggle="tooltip" data-placement="top" title="<spring:message code="listScans.refresh"/>"><i class="fas fa-sync"></i> </button></a>
        </p>
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
    </jsp:attribute>

    <jsp:attribute name="script"> 
         <style>      
                               
           #serverDatatables_processing
           {
            margin-top: -1%;      
            z-index: 1200;              
           }
           #runningScans_processing
           {
            margin-top: -6%;      
            z-index: 1200;              
           }
           #scheduledScans_processing
           {
            margin-top: -6%;      
            z-index: 1200;              
           }
         
           
        </style>      
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        <script type="text/javascript">
            document.title = "<spring:message code="main.theme.hostScan"/> - BIZZY";
            function deleteScans() {
                function confirmDelete() {

                    var scanIds = [];
                    $('[id=selectedScan]:checked').each(function () {
                        scanIds.push($(this).val());
                    });
                    $.post("deleteAssetDiscoveries.json", {
                        'scanIds': scanIds, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        oTable.fnDraw();
                        runningTable.fnDraw();
                    });

                }

                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="generic.deleteMultiple"/>"), confirmDelete);
            }

            function activaTab(tab) {
                $('.nav-tabs a[href="#' + tab + '"]').tab('show');
            }

            var currentTab = 'first';
            function updateCurrentTab(tab) {
                currentTab = tab;
                switch (currentTab) {
                    case 'first':
                        $('#serverDatatables').DataTable().clear();
                        $('#serverDatatables').on('load', loadCompletedScans());
                        break;

                    case 'second':
                        $('#runningScans').DataTable().clear();
                        $('#runningScans').on('load', loadRunningScans());
                        break;

                    case 'third':
                        $('#scheduledScans').DataTable().clear();
                        $('#scheduledScans').on('load', loadScheduledScans());
                        break;
                }
            }

            $("#startScanBtn").click(function () {
                window.location = "startAssetDiscovery.htm";
            });

            if (localStorage.getItem("hostScanCreated") === 'listCompleted') {
                activaTab('tab1default');
                currentTab = 'first';
                localStorage.setItem("hostScanCreated", null);
            } else if (localStorage.getItem("hostScanCreated") === 'listRunning') {
                activaTab('tab2default');
                currentTab = 'second';
                localStorage.setItem("hostScanCreated", null);
            } else if (localStorage.getItem("hostScanCreated") === 'listScheduled') {
                activaTab('tab3default');
                currentTab = 'third';
                localStorage.setItem("hostScanCreated", null);
            }

            var oTable;
            var runningTable;
            var scheduledTable;
            var timeoutVar;
            var waitingTime = 360000;
            function update() {
                oTable.api().ajax.reload();
            };            
            $(document).ready(function () {
                $('#serverDatatables').on('load', loadCompletedScans());
                $('#runningScans').on('load', loadRunningScans());
                $('#scheduledScans').on('load', loadScheduledScans());
                $('.dataTables_filter input')
                        .unbind()
                        .bind('keypress keyup', function (e) {
                            var length = $(this).val().length;
                            var keyCode = e.keyCode;
                            if (length >= 3 && keyCode === 13) {
                                oTable.fnFilter($(this).val());
                                scheduledTable.fnFilter($(this).val());
                            } else if (length === 0) {
                                oTable.fnFilter("");
                                scheduledTable.fnFilter("");
                            }
                        }).attr("placeholder", decodeHtml("<spring:message code="listQualysScans.searchTip" htmlEscape="false"/>")).width('220px');
            });
            function loadCompletedScans() {
                oTable = $('#serverDatatables').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "processing": true,
                    "bDestroy": true,
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
                        {data: "id",
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
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.empty"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
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
                        {"data": 'target'},
                        {"data": function (data, type, dataToSet) {
                                if (data.excludeIps == "" || data.excludeIps == null) {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.excludeIps;
                                }
                            }, "orderable": false, "searchable": false
                        },
                        {"data": 'activeHostsCount', "searchable": false, "orderable": false},
                        {"data": function (data, type, dataToSet) {
                                if (data.newHostsCount == "-1") {
                                    return '<i class="fas fa-minus"></i>';
                                }
                                return data.newHostsCount;
                            }, "searchable": false, "orderable": false},
                        {"mData": 'source', "searchable": false, "orderable": false,
                            "render": function (data) {
                                return getScannerLogo(data,'${pageContext.request.contextPath}');
                            }
                        },
                        {"data": 'requestDate'},
                        {"data": 'completionDate'},
                        {"data": function (data, type, dataToSet) {
                                if (data.resultAction === null) {
                                    return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                } else {
                                    switch (data.resultAction) {
                                        case "1" :
                                            return '<spring:message code="startAssetDiscovery.saveAssets"/>';
                                            break;
                                        case "2" :
                                            return '<spring:message code="startAssetDiscovery.scanAllAssets"/>';
                                            break;
                                        case "3" :
                                            return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                            break;
                                        case "4" :
                                            return '<spring:message code="startAssetDiscovery.scanNewAssets"/>';
                                            break;
                                        case "5" :
                                            return '<spring:message code="startAssetDiscovery.createAlarm"/>';
                                            break;
                                        default :
                                            return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                            break;
                                    }

                                }

                            },
                            "searchable": false,
                            "orderable": false
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
                        "url": "loadAssetDiscoveries.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
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
                        $("#tabScansHeader").html('<spring:message code="listAssetDiscoveries.completed"/>' + ' (' + oSettings._iRecordsTotal + ')');
                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        $('[data-toggle="tooltip"]').tooltip();
                        setTimeout(function(){
                            $('#serverDatatables').DataTable().columns.adjust().draw();
                        });  
                    }
                });            
            }
            function loadRunningScans() {
                runningTable = $('#runningScans').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "processing": true,
                    "serverSide": true,
                    "scrollX": true,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', width: 10, targets: 0 },
                        { className: 'noVis', targets: 9 }
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
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
                        {data: "id",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" id="selectedScan2" style="display:block; margin:0 auto; vertical-align:middle; " value="' + data + '" >';
                                }
                                return data;
                            },
                            "searchable": false,
                            "orderable": false
                        },                        
                        {"data": 'name', "width": "20%"},
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
                                        return '<div class="progress"><div id="' + data.scanId + '" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="0" style="width:0%">%0</d></div>';
                                    case "RUNNING" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="listScans.running"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/oval.svg" width="25"/></div>';
                                    case "CANCELED" :
                                        return '<div><img data-toggle="tooltip" data-placement="right" title="<spring:message code="ScanStatus.CANCELED"/>" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/cross.svg" width="25"/></div>';
                                    default :
                                        return '<div class="riskLevel2 riskLevelCommon">'+ data.status.name +'</div>';
                                }
                            }
                        },
                        {"data": 'scanDate'},
                        {"data": 'target'},
                        {"data": function (data, type, dataToSet) {
                                if (data.excludeIps == "" || data.excludeIps == null) {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.excludeIps;
                                }
                            }, "orderable": false, "searchable": false
                        },
                        {"mData": 'source', "searchable": false, "orderable": false,
                            "render": function (data) {
                                return getScannerLogo(data,'${pageContext.request.contextPath}');
                            }
                        },
                        {"data": 'requestDate'},
                        {"data": function (data, type, dataToSet) {
                                if (data.resultAction === null) {
                                    return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                } else {
                                    switch (data.resultAction) {
                                        case "1" :
                                            return '<spring:message code="startAssetDiscovery.saveAssets"/>';
                                            break;
                                        case "2" :
                                            return '<spring:message code="startAssetDiscovery.scanAllAssets"/>';
                                            break;
                                        case "3" :
                                            return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                            break;
                                        case "4" :
                                            return '<spring:message code="startAssetDiscovery.scanNewAssets"/>';
                                            break;
                                        case "5" :
                                            return '<spring:message code="startAssetDiscovery.createAlarm"/>';
                                            break;
                                        default :
                                            return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                            break;
                                    }

                                }

                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                return '<button onClick="deleteRow(\'' + data.id + '\', this)" name="delete" type="button" class="btn btn-danger btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="listScans.stopAndDelete"/>"><i class="fas fa-times"></i> </button>  ';
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "order": [3, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadRunningAssetDiscoveries.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
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
                        $("#tabRunningHeader").html('<spring:message code="listAssetDiscoveries.running"/>' + ' (' + oSettings._iRecordsTotal + ')');
                    },
                    "initComplete": function (settings, json) {
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>");
                        $('[data-toggle="tooltip"]').tooltip();
                        setTimeout(function(){
                            $('#runningScans').DataTable().columns.adjust().draw();
                        });                         
                    }
                });
            }
            function loadScheduledScans() {
                scheduledTable = $('#scheduledScans').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "dom": "<'row'<'col-sm-10'fB><'col-sm-2'l>>rtip",
                    "bDestroy": true,
                    "processing": true,
                    "serverSide": true,
                    "scrollX": true,
                    "stateSave": true,
                    "columnDefs": [
                        { className: 'noVis', targets: 11 }
                    ],
                    "buttons": [
                        {
                            extend: 'colvis',
                            columns: ':not(.noVis)'
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
                    "fnRowCallback": function (row, data, index) {
                        let reccurence = parseInt(data.recurrence);
                        let occurrence = data.launch;
                        if (occurrence !== "ON_DEMAND" && reccurence !== -1) {
                            let completed = data.completedScanCount;
                            let remaining = reccurence - completed;
                            let threshold = Math.ceil(reccurence / 10);
                            if (remaining <= threshold) {
                                $('td', row).css('background-color', '#FF6666');
                            }
                        }
                    },
                    "columns": [
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
                                if (data.recurrence === -1) {
                                    return '</div><spring:message code="scheduledScans.CompletedScanCount"/></a>';
                                } else {
                                    return data.recurrence;
                                }

                            }, "searchable": false, "orderable": false
                        },
                        {"data": 'launch', "searchable": false, "orderable": false},
                        {"data": 'target'},
                        {"data": function (data, type, dataToSet) {
                                if (data.excludeIps == "" || data.excludeIps == null) {
                                    return '<i class="fas fa-minus"></i>';
                                } else {
                                    return data.excludeIps;
                                }
                            }, "orderable": false, "searchable": false
                        },
                        {"mData": 'source', "searchable": false, "orderable": false,
                            "render": function (data) {
                                return getScannerLogo(data,'${pageContext.request.contextPath}');
                            }
                        },
                        {"data": 'requestDate'},
                        {"data": function (data, type, dataToSet) {
                                if (data.resultAction == null) {
                                    return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                } else {
                                    switch (data.resultAction) {
                                        case "1" :
                                            return '<spring:message code="startAssetDiscovery.saveAssets"/>';
                                            break;
                                        case "2" :
                                            return '<spring:message code="startAssetDiscovery.scanAllAssets"/>';
                                            break;
                                        case "3" :
                                            return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                            break;
                                        case "4" :
                                            return '<spring:message code="startAssetDiscovery.scanNewAssets"/>';
                                            break;
                                        case "5" :
                                            return '<spring:message code="startAssetDiscovery.createAlarm"/>';
                                            break;
                                        default :
                                            return '<spring:message code="startAssetDiscovery.doNotTakeAction"/>';
                                            break;
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                return getScheduledScanActions(data);
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "order": [2, 'asc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadScheduledAssetDiscoveries.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
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
                        $("#tabScheduledHeader").html('<spring:message code="listAssetDiscoveries.scheduled"/>' + ' (' + oSettings._iRecordsTotal + ')');
                        $("[name*='active-']").bootstrapSwitch();
                    },
                    "initComplete": function (settings, json) {
                        scheduledTable.fnAdjustColumnSizing();
                        $(".dt-button").html("<span><spring:message code="generic.modifyColumns"/></span>"); 
                        $('[data-toggle="tooltip"]').tooltip();
                        setTimeout(function(){
                            $('#scheduledScans').DataTable().columns.adjust().draw();
                        });                         
                    }
                });
            }
            function getScanType(data) {
                if (data.scheduled) {
                    return 'SCHEDULED';
                } else {
                    return 'ONE TIME';
                }
            }
            function getScanActions(data) {
                var html = '';
                html += '<a href="listAssetDiscoveryResults.htm?scanId=' + data.id + '" class="btn btn-info btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="listScans.viewResult"/>"><i class="fas fa-info-circle"></i> </a>  ';
                html += '<button onClick="deleteRow(\'' + data.id + '\', this)" name="delete" type="button" class="btn btn-danger btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="generic.delete"/>"><i class="fas fa-times"></i> </button>  ';
                return html;
            }
            
             function allRecords3Function() {
                if ($('#selectAll3').is(":checked")) {
                    $('#allRecords').show();
                } else {
                    $('#allRecords').hide();
                    $("#checkBoxAllRecords").prop('checked', false);
                }
            }
            
            function getScheduledScanActions(data) {
                var html = '';
                html += '<button onClick="startScanNow(\'' + data.id + '\')" name="scanNow" type="button" class="btn btn-info btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="listScans.startImmediately"/>"><i class="fas fa-play"></i></button>   ';
                html += '<a href="editScheduledHostScan.htm?id=' + data.id + '" class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="generic.edit"/>"><i class="fas fa-pen-square"></i></a>  ';
                html += '<button onClick="deleteSchedueldRow(\'' + data.id + '\', this)" name="delete" type="button" class="btn btn-danger btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="generic.delete"/>"><i class="fas fa-times"></i> </button>   ';
                return html;
            }
            var changeCheck = 0;
            function getScheduledScanStatusAction(data) {
                var html = '';
                if (data.active) {
                    html += '<spring:message code="listScans.active"/>';
                } else {
                    html += '<spring:message code="genericdb.passive"/>';
                }
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                html = '';
                $("[name = 'active-" + data.id + "']").bootstrapSwitch();
                $("#scheduledScans").on('switchChange.bootstrapSwitch', "input[name='active-" + data.id + "']", function (event, state) {
                    sendAjaxOnClick(data.id, state);
                });
                var checkState = "";
                if (data.active)
                    checkState = "checked";
                html += '<a><input type="checkbox" name="active-' + data.id + '" data-size="small" data-on-text="<spring:message code="listScans.active"/>" data-off-text="<spring:message code="genericdb.passive"/>" onclick="onClickHandler()" ' + checkState + '></a>';
            </sec:authorize>
                return html;
            }
            function sendAjaxOnClick(id, status) {
                changeCheck += 1;
                if(changeCheck === 1){
                $.ajax({
                    type: "POST",
                    url: "changeScheduledHostStatus.json",
                    data: {"id": id, "status": status, "${_csrf.parameterName}": "${_csrf.token}"},
                    success: function (data) {
                        changeCheck = 0;
                        if (data.success) {
                            return;
                        } else {
                            console.log("ERROR!!!");
                            return;
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                    }
                });
                }
            }
            function deleteSchedueldRow(id, deletedElement) {

                function confirmDeleteScheduled() {

                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteScheduledAssetDiscovery.json", {scanId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        //        scheduledTable.fnDeleteRow(nRow);
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        scheduledTable.api().draw();
                        localStorage.setItem("hostScanCreated", "listScheduled");
                        location.reload();
                    });

                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="generic.confirmDeleteScan"/>"), confirmDeleteScheduled);

            }

            function deleteRow(id, deletedElement) {

                function confirmDelete() {
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteAssetDiscovery.json", {scanId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        //    oTable.fnDeleteRow(nRow);
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        oTable.fnDraw();
                        runningTable.fnDraw();
                    });

                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="generic.confirmDeleteScan"/>"), confirmDelete);
            }

        </script>

        <script type="text/javascript">
            //Default checked
            $("#pentestScan").prop('checked', true);
            var temp = {};
            $('#buttonback2').on('click', function () {
                $('#sameAsset').hide();
            });
            $('#dateTimeScan').datetimepicker({
            });
            $("#scanAssets").select2({
                tags: true
            });
            $("#addedasset").select2({
                tags: true
            });
            $("#excludeAssets").select2({
                tags: true
            });

            //Tarama statuslerini ve tablolaro günceller.
            function refresh() {
                blockUILoading();
                $.post("refreshAssetDiscoveryStatus.json", {${_csrf.parameterName}: "${_csrf.token}"}, function () {
                }).done(function () {
                }).fail(function () {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listScans.refreshFail"/>");
                    $("#alertModal").modal("show");
                }).always(function () {
                    unBlockUILoading();
                    switch (currentTab) {

                        case 'first':
                            localStorage.setItem("hostScanCreated", "listCompleted");
                            break;

                        case 'second':
                            localStorage.setItem("hostScanCreated", "listRunning");
                            break;

                        case 'third':
                            localStorage.setItem("hostScanCreated", "listScheduled");
                            break;

                        default:
                            localStorage.setItem("hostScanCreated", "listCompleted");
                            break;
                    }
                    location.reload();
                });
            }

            function displayAutoScan(div, status) {
                if ($('#pentestScan').is(":checked")) {
                    document.getElementById("autoScan").style.display = 'none';
                } else {
                    document.getElementById("autoScan").style.display = 'block';
                }
            }

            $('#resultAction').on('change', function () {
                if ($('#resultAction').val() === '2') {
                    if ($('#policyDiv').is(':visible')) {
                        $('#policyDivForScan').show();
                    }
                } else {
                    $('#policyDivForScan').hide();
                }
            });

            $('#recurrence').val(1);
            $('#recurrence').attr("disabled", "disabled");

            $('#launch').on('change', function () {
                if ($('#launch').val() === "ON_DEMAND") {
                    $('#recurrence').val(1);
                    $('#recurrence').attr("disabled", "disabled");
                } else {
                    $('#recurrence').val("");
                    $('#recurrence').removeAttr("disabled");
                }
            });
            
            function startScanNow(scanId){
                function confirmStartScanNow(){
                    blockUILoading();
                    $.post("startScheduledHostScanNow.json", {
                        'scanId': scanId,
                        ${_csrf.parameterName}: "${_csrf.token}" }, function () {
                    }).done(function (data) {
                        if(data.status === "success"){
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.instantHostScanSucceeded"/>");
                            $("#alertModal").modal("show");
                        } else if(data.status === "failed"){
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.errorInInstantHostScan"/>");
                            $("#alertModal").modal("show");
                        }
                }).fail(function () {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="listScans.errorInInstantHostScan"/>>");
                    $("#alertModal").modal("show");
                }).always(function () {
                    oTable.api().ajax.reload();
                    runningTable.api().ajax.reload();
                    scheduledTable.api().ajax.reload();
                    unBlockUILoading();
                    $("[name*='active-']").bootstrapSwitch();
                });
            }
            jsInformationOkCancelModalFunction("<spring:message code="listScans.startHostScanNow"/>", confirmStartScanNow);
            }
            
        </script>    

    </jsp:attribute>    

    <jsp:body>

        <div class="panel with-nav-tabs panel-default">
            <div class="tabbable-custom nav justified">
                <ul class="nav nav-tabs nav-justified">
                    <li class="active" ><a onClick="updateCurrentTab('first');" style="text-decoration:none;color:#428bca" href="#tab1default" data-toggle="tab"><div id="tabScansHeader"></div></a></li>
                    <li><a onClick="updateCurrentTab('second');" style="text-decoration:none;color:#428bca" href="#tab2default" data-toggle="tab"><div id="tabRunningHeader"></div></a></li>
                    <li><a onClick="updateCurrentTab('third');" style="text-decoration:none;color:#428bca" href="#tab3default" data-toggle="tab"><div id="tabScheduledHeader"></div></a></li>
                </ul>
            </div>
            <div class="panel-body">      
                <div class="tab-content">
                    <div class="tab-pane fade in active" id="tab1default">
                        <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" tyle="width: 100% !important;">
                            <thead class="datatablesThead">
                                <tr>
                                    <th><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('selectedScan');" ></th>

                                    <th><spring:message code="listScans.name"/></th> 
                                    <th><spring:message code="listScans.status"/></th>
                                    <th><spring:message code="listScans.scanDate"/></th>
                                    <th><spring:message code="listScans.target"/></th>
                                    <th><spring:message code="listScans.excludeIps"/></th>
                                    <th><spring:message code="listScans.activeHostsCount"/></th>
                                    <th><spring:message code="listScans.newHostsCount"/></th>
                                    <th><spring:message code="listScans.source"/></th>
                                    <th><spring:message code="listScans.requestDate"/></th>
                                    <th><spring:message code="listScans.completionDate"/></th>
                                    <th><spring:message code="listScans.actionAfterDiscovery"/></th>
                                    <th style="vertical-align: middle; min-width: 60px;"><div></div></th>
                                </tr>
                            </thead>                                
                        </table>
                    </div>
                    <div class="tab-pane fade" id="tab2default">
                        <table width="100%" class="table table-striped table-bordered table-hover" id="runningScans" style="width: 100% !important;">
                            <thead id="runningScanTableThead" style="width: 100%;" class="datatablesThead">
                                <tr>
                                    <th><input type="checkbox" class="editor-active" id="selectAll3" onclick="allRecords3Function();
                                                                    selectAll2('selectAll3', 'selectedScan2');" ></th>
                                    <th><spring:message code="listScans.name"/></th> 
                                    <th><spring:message code="listScans.status"/></th>
                                    <th><spring:message code="listScans.scanDate"/></th>
                                    <th><spring:message code="listScans.target"/></th>
                                    <th><spring:message code="listScans.excludeIps"/></th>
                                    <th><spring:message code="listScans.source"/></th>
                                    <th><spring:message code="listScans.requestDate"/></th>
                                    <th><spring:message code="listScans.actionAfterDiscovery"/></th>
                                    <th style="vertical-align: middle; min-width: 30px;"><div></div></th>
                                </tr>
                            </thead>                                
                        </table>
                    </div>
                    <div class="tab-pane fade" id="tab3default">
                        <table width="100%" class="table table-striped table-bordered table-hover" id="scheduledScans" style="width: 100%;">
                            <thead class="datatablesThead">
                                <tr>

                                    <th><spring:message code="listScans.name"/></th> 
                                    <th style="vertical-align: middle; min-width: 100px;"><spring:message code="listScans.status"/></th>
                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.previousScanDate"/></th>
                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.nextScanDate"/></th>
                                    <th><spring:message code="startQualysScan.recurrence"/></th>
                                    <th><spring:message code="startQualysScan.frequency"/></th>
                                    <th><spring:message code="listScans.target"/></th>
                                    <th><spring:message code="listScans.excludeIps"/></th>
                                    <th> <spring:message code="listScans.source"/></th>
                                    <th style="vertical-align: middle; min-width: 132px;" width="132px"><spring:message code="listScans.requestDate"/></th>
                                    <th style="vertical-align: middle; min-width: 132px;" width="132px" ><spring:message code="listScans.actionAfterDiscovery"/></th> 
                                    <th style="vertical-align: middle; min-width: 90px;"><div></div></th>
                                </tr>
                            </thead>                                
                        </table>
                    </div>
                </div>
                                    
            </div>
        </div>

        <style>  
            .dt-button {
                margin-left: 5px !important; 
                margin-top: 28px !important;
                float: left !important;
                display: inline;
                z-index: 1;
                left: 20% !important;
            }
            div.dataTables_wrapper div.dataTables_filter {
                text-align: left;
                display: center;
                left:5% !important;
            }
            .dataTables_length {
                text-align: right;
            }            
            
        </style>            
    </jsp:body>    


</biznet:mainPanel>