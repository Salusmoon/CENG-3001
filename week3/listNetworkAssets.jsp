<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<biznet:mainPanel viewParams="title,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb" >
            <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="networkTopology.assets"/></span>
            </li>
        </ul>
    </jsp:attribute>
    <jsp:attribute name="script">
         <style>
         
            
           #networkAssetsDatatable_processing
           {
            margin-top: -6%;      
            z-index: 1200;              
           }
           
            #networkAssetDatatable_processing
           {
            margin-top: -5%;      
            z-index: 1200;              
           }
           
        </style>
        <script type="text/javascript">
            var table, table2;
            document.title = "<spring:message code="networkTopology.assets"/> - BIZZY";
            $(document).ready(function () {
                var snaptable = $('#displaySnapshotTable').DataTable();
                $('#displaySnapshotTable tbody').on('click', 'tr', function () {
                    $("#snapshotDetails").modal();
                    let snapshotDate = snaptable.row(this).data().date;
                    /*snaptable.row(this).data().networkAssetModel.forEach(function (element) {
                     assetString += element.routerAsset + ",";
                     });*/
                    showSnapshot(snapshotDate);
                    /*document.getElementById("title-modal").innerHTML = table2.row(this).data().competitorName;
                     document.getElementById("score-number-modal").innerHTML = table2.row(this).data().score;
                     document.getElementById("on-time-modal").innerHTML = table2.row(this).data().rightOnTimeCommit;
                     document.getElementById("late-modal").innerHTML = table2.row(this).data().lateCommit;
                     document.getElementById("rankLabel-modal").innerHTML = "<spring:message code="viewScoreboard.rank"/> : " + table2.row(this).data().place;*/
                });
            });
            $('#helpBtn').click(function () {
                var helpContent = '<hr><h5><b><spring:message code="listNetworkAssets.importFromCSV"/> </b></h5><p><spring:message code="listNetworkAssets.importHelp1"/></p>';
                helpContent += '<a href="${context}/topology/getDataFile.htm?type=CSV" class="btn btn-link btn-xs"><span class="fa-stack fa-x"><strong class="fa-stack-1x fa-stack-text file-text">bizzy_network_topology_asset_example.csv</strong></span></a>';
                helpContent += '<p><spring:message code="listNetworkAssets.importHelp2"/></p>';
                if ($('#helpMessage').html().length > 1) {
                    $('#helpMessage').html();
                } else {
                    $('#helpMessage').html(helpContent);
                }
            });
            var dArr = {};
            var url = "searchNetworkAssetModels.json";
            table = $('#networkAssetsDatatable').dataTable({
                "processing": true,
                "scrollX": true,
                "serverSide": true,
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
                    "url": url,
                    "data": function (d) {
                        d.${_csrf.parameterName} = "${_csrf.token}";
                    }
                },
                "searching": false,
                "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                "destroy": true,
                "columnDefs": [
                    {
                        "width": "30%",
                        "targets": 3
                    }
                ],
                "columns": [{
                        "sortable": false,
                        "data": function (res) {
                            if (res.routerAsset !== null)
                                return res.routerAsset;
                            else
                                return "<i class=\"fas fa-minus\"></i>";
                        }
                    }, {
                        "sortable": false,
                        "data": function (res) {
                            if (res.duoAssets !== null)
                                return toInterfaceAssetList(res);
                            else
                                return "<i class=\"fas fa-minus\"></i>";
                        }
                    }, {
                        "sortable": false,
                        "data": function (res) {
                            if (res.duoAssets !== null)
                                return toSubnetAssetList(res);
                            else
                                return "<i class=\"fas fa-minus\"></i>";
                        }
                    }, {
                        "sortable": false,
                        "data": function (res) {
                            if (res.duoAssets !== null)
                                return toHostAssetList(res);
                            else
                                return "<i class=\"fas fa-minus\"></i>";
                        }
                    }, {
                        "sortable": false,
                        "data": "routerAsset",
                        "render": function (data) {
                            return actions(data);
                        }
                    }],
                "fnDrawCallback": function () {
                }
            });

            function showSnapshot(router) {
                var url = "searchNetworkAssetModels.json";
                table = $('#networkAssetDatatable').dataTable({
                    "processing": true,
                    "serverSide": true,
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
                        "url": url,
                        "data": function (d) {
                            d.routerAsset = router;
                            d.issnapshot = true;
                            d.${_csrf.parameterName} = "${_csrf.token}";
                        }
                    },
                    "searching": false,
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "destroy": true,
                    "columnDefs": [
                        {
                            "width": "30%",
                            "targets": 3
                        }
                    ],
                    "columns": [{
                            "sortable": false,
                            "data": function (res) {
                                if (res.routerAsset !== null)
                                    return res.routerAsset;
                                else
                                    return "<i class=\"fas fa-minus\"></i>";
                            }
                        }, {
                            "sortable": false,
                            "data": function (res) {
                                if (res.duoAssets !== null)
                                    return toInterfaceAssetList(res);
                                else
                                    return "<i class=\"fas fa-minus\"></i>";
                            }
                        }, {
                            "sortable": false,
                            "data": function (res) {
                                if (res.duoAssets !== null)
                                    return toSubnetAssetList(res);
                                else
                                    return "<i class=\"fas fa-minus\"></i>";
                            }
                        }, {
                            "sortable": false,
                            "data": function (res) {
                                if (res.duoAssets !== null)
                                    return toHostAssetList(res);
                                else
                                    return "<i class=\"fas fa-minus\"></i>";
                            }
                        }],
                    "fnDrawCallback": function () {
                    }
                });
            }
            table2 = $('#displaySnapshotTable').dataTable({
                "processing": true,
                "scrollX": true,
                "serverSide": true,
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
                    "url": "getAllTopologySnapshots.json",
                    "data": function (d) {
                        d.${_csrf.parameterName} = "${_csrf.token}";
                    }
                },
                "searching": false,
                "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                "destroy": true,
                "columnDefs": [
                    {
                        "width": "30%",
                        "targets": 3
                    }
                ],
                "columns": [{
                        "sortable": false,
                        "data": function (res) {
                            if (res.date !== null){
                                var date = new Date(res.date);
                                return date.toLocaleDateString() + " " +  date.toLocaleTimeString();
                            }
                            else{
                               return "<i class=\"fas fa-minus\"></i>";
                           }
                        }
                    }, {
                        "sortable": false,
                        "data": function (res) {
                            if (res.networkAssetModel !== null)
                                return res.networkAssetModel.length;
                            else
                                return "<i class=\"fas fa-minus\"></i>";
                        }
                    }, {
                        "sortable": false,
                        "data": function (res) {
                            if (res.networkAssetModel !== null) {
                                let count = 0;
                                res.networkAssetModel.forEach(function (element) {
                                    count += element.duoAssets.length;
                                });
                                return count;
                            } else
                                return "<i class=\"fas fa-minus\"></i>";
                        }
                    }, {
                        "sortable": false,
                        "data": "date",
                        "render": function (data) {
                            return listSnapshotActions(data);
                        }
                    }],
                "fnDrawCallback": function () {
                }
            });
            $("#searchBtn").click(function (e) {
                e.preventDefault();
                reloadData(table, dArr, url);
            });

            /* Datatable operations starts */
            // in filter input, inputs must have id which is same attribute in filters model.
            function reloadData(table, array, url) {
                array = {};
                $.each($(".filters :input"), function (x, y) {
                    if ($("#" + y.id).val() !== "false") {
                        setArrayValue(array, y.id);
                    }
                });

                reloadTable(table, array, url);
            }

            function reloadTable(table, array, url) {
                table.api().ajax.url(url + buildStr(array)).load();
            }

            function setArrayValue(array, key) {
                if ($("#" + key).val() !== null && $("#" + key).val() !== '')
                    array[key] = $("#" + key).val();
            }

            function buildStr(d) {
                var retval = '';
                var c = 0;
                $.each(d, function (i, val) {
                    if (c === 0) {
                        retval += "?" + i + "=" + val;
                    } else {
                        retval += "&" + i + "=" + val;
                    }
                    c++;
                });
                return retval;
            }

            function actions(data) {
                var html = '';
                html += '<a href="${context}/topology/updateNetworkAsset.htm?routerAssetLabel=' + data + '" title="<spring:message code="generic.edit"/>" class="btn btn-sm green btn-outline sbold"><i class="fas fa-pen-square"></i></a>';
                html += '<button onClick="deleteRow(\'' + data + '\', this)" name="delete" title="<spring:message code="generic.delete"/>" type="button" class="btn btn-sm red btn-outline sbold"><i class="fas fa-times"></i></button>';
                return html;
            }
            function listSnapshotActions(data) {
                var html = '';
                html += '<button onClick="deleteSnapshotRow(\'' + data + '\', this)" name="delete" title="<spring:message code="generic.delete"/>" type="button" class="btn btn-sm red btn-outline sbold"><i class="fas fa-times"></i></button>';
                return html;
            }
            /* Datatable operations ends */

            function deleteRow(routerAsset, deletedElement) {
                var r = confirm(decodeHtml("<spring:message code="generic.confirmDelete"/>"));
                if (r === true) {
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("${context}/topology/deleteNetworkAsset", {routerAssetLabel: routerAsset, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        /* table.fnDeleteRow(nRow); */
                        location.href = "${context}/topology/listNetworkAssets.htm";
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });
                }
            }
            function deleteSnapshotRow(date, deletedElement) {
                var r = confirm(decodeHtml("<spring:message code="generic.confirmDelete"/>"));
                if (r === true) {
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("${context}/topology/deleteTopologySnapshot", {date: date, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        /* table.fnDeleteRow(nRow); */
                        location.href = "${context}/topology/listNetworkAssets.htm";
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });
                }
            }
            function deleteAllSnapshots() {
                var r = confirm(decodeHtml("<spring:message code="generic.confirmDelete"/>"));
                if (r === true) {
                    $.post("${context}/topology/deleteAllTopologySnapshots", {${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        /* table.fnDeleteRow(nRow); */
                        location.href = "${context}/topology/listNetworkAssets.htm";
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });
                }
            }
            function toInterfaceAssetList(networkAsset) {
                var html = '<ol>';
                var count = 0;
                if (networkAsset !== null) {
                    if (networkAsset.duoAssets !== null && networkAsset.duoAssets.length > 0) {
                        var duoAssets = networkAsset.duoAssets;
                        for (var i = 0; i < duoAssets.length; i++) {
                            var duoAsset = duoAssets[i];
                            if (duoAsset !== null && duoAsset.interfaceAsset !== null && duoAsset.interfaceAsset !== "") {
                                html += "<li>" + duoAsset.interfaceAsset + "</li>";
                            } else {
                                html += "<li><i class=\"fas fa-minus\" style=\"padding-left: 30px;\"></i></li>";
                            }
                            count++;
                        }
                    }
                }
                html += "</ol>";
                if (count > 0) {
                    return html;
                } else {
                    return "<i class=\"fas fa-minus\"></i>";
                }
            }

            function toSubnetAssetList(networkAsset) {
                var html = '<ol>';
                var count = 0;
                if (networkAsset !== null) {
                    if (networkAsset.duoAssets !== null && networkAsset.duoAssets.length > 0) {
                        var duoAssets = networkAsset.duoAssets;
                        for (var i = 0; i < duoAssets.length; i++) {
                            var duoAsset = duoAssets[i];
                            if (duoAsset !== null && duoAsset.subnetAsset !== null && duoAsset.subnetAsset !== "") {
                                html += "<li>" + duoAsset.subnetAsset + "</li>";
                            } else {
                                html += "<li><i class=\"fas fa-minus\" style=\"padding-left: 30px;\"></i></li>";
                            }
                            count++;
                        }
                    }
                }
                html += "</ol>";
                if (count > 0) {
                    return html;
                } else {
                    return "<i class=\"fas fa-minus\"></i>";
                }
            }

            function toHostAssetList(networkAsset) {
                var html = '<ol>';
                var count = 0;
                if (networkAsset !== null) {
                    if (networkAsset.duoAssets !== null && networkAsset.duoAssets.length > 0) {
                        var duoAssets = networkAsset.duoAssets;
                        for (var i = 0; i < duoAssets.length; i++) {
                            var duoAsset = duoAssets[i];
                            if (duoAsset !== null && duoAsset.hosts !== null && duoAsset.hosts.length > 0) {
                                var hostAssetOutput = '';
                                duoAsset.hosts.forEach(function (hostAsset, index) {
                                    hostAssetOutput += hostAsset.ip;
                                    if (hostAsset.natIps !== undefined && hostAsset.natIps !== null && hostAsset.natIps.length > 0) {
                                        hostAssetOutput += '(';
                                        hostAssetOutput += hostAsset.natIps.join(' & ');
                                        hostAssetOutput += ')';
                                    }
                                    if (index !== duoAsset.hosts.length - 1) {
                                        hostAssetOutput += ", ";
                                    }
                                });
                                html += "<li>" + hostAssetOutput + "</li>";
                            } else {
                                html += "<li><i class=\"fas fa-minus\" style=\"padding-left: 30px;\"></i></li>";
                            }
                            count++;
                        }
                    }
                }
                html += "</ol>";
                if (count > 0) {
                    return html;
                } else {
                    return "<i class=\"fas fa-minus\"></i>";
                }
            }
            
            $('[href=#assetsTab]').on('shown.bs.tab', function (e) {
                table.api().ajax.reload();
                $('#networkAssetsDatatableThead').resize();
            });
            $('[href=#topologySnapshotsTab]').on('shown.bs.tab', function (e) {
                table2.api().ajax.reload();
                $('#displaySnapshotTableThead').resize();
            });

            $('#createTopologyBtn').click(function () {
                createTopology();
            });

            function createTopology() {
                App.blockUI({
                    animate: true
                });
                $.get("${context}/topology/createManualTopology", function () {
                }).done(function () {
                    App.alert({
                        type: 'success',
                        close: true,
                        focus: true,
                        icon: 'check',
                        closeInSeconds: "7",
                        message: '<spring:message code="networkTopology.topologySaveSuccess"/>',
                        container: $("#assetTabBody"),
                        place: 'prepend'
                    });
                }).fail(function () {
                    App.alert({
                        type: 'danger',
                        close: true,
                        focus: true,
                        icon: 'times',
                        closeInSeconds: "7",
                        message: '<spring:message code="networkTopology.topologySaveFail"/>',
                        container: $("#assetTabBody"),
                        place: 'prepend'
                    });
                }).always(function () {
                    App.unblockUI();
                });
            }
        </script>
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
    </jsp:attribute>
    <jsp:body>
        <c:set var="context" value="${pageContext.request.contextPath}" />

        <div class="row">
            <div class="col-md-12">
                <div class="panel with-nav-tabs panel-default">
                    <div class="tabbable-custom nav justified">
                        <ul class="nav nav-tabs nav-justified">
                            <li class="active" ><a id="start" style="text-decoration:none;color:#428bca" href="#assetsTab" data-toggle="tab"><spring:message code="networkTopology.assets"/></a></li>
                            <li><a  style="text-decoration:none;color:#428bca" href="#topologySnapshotsTab" data-toggle="tab"><spring:message code="listNetworkAssets.topologySnapshots"/></a></li>                
                        </ul>
                    </div>
                    <div class="panel-body">
                        <div class="tab-content">
                            <div class="tab-pane fade in active" id="assetsTab">
                                <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY')">
                                    <div class="row">
                                        <div class="col-lg-12" id="data">     
                                            <div class="portlet  portlet-fit">
                                                <div class="portlet-title">
                                                    <div class="actions">
                                                        <a class="expandableBtn btn btn-sm  red  right-aligned" href="${context}/topology/addNetworkAsset.htm"> <i class="fas fa-plus"></i>
                                                            <span><spring:message code="listNetworkAssets.addNew"></spring:message></span>
                                                            </a>
                                                            <a data-toggle="modal" href="#fileImport" class="expandableBtn btn btn-sm yellow  right-aligned"><i class="icon-docs"></i>
                                                                <span><spring:message code="listNetworkAssets.import"></spring:message></span>
                                                            </a>
                                                            <a id="createTopologyBtn" class="expandableBtn btn btn-sm blue  right-aligned" > <i class="fas fa-cogs"></i>
                                                                <span><spring:message code="listNetworkAssets.createTopology"></spring:message></span>
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div id="assetTabBody" class="portlet-body">
                                                        <form class="filters" autocomplete="off">
                                                            <div class="row" style="margin-top:15px">
                                                                <div class="col-lg-2 col-md-2">
                                                                    <div class="form-group form-md-line-input" style="padding-top:0; margin-bottom:0">
                                                                        <select class="bs-select form-control" id="routerAsset" data-live-search="true" data-size="8" style="font-size:12px">
                                                                            <option value=""><spring:message code="networkTopology.assets"></spring:message></option>
                                                                        <c:forEach items="${filters}" var="routerAsset">
                                                                            <option value="<c:out value="${routerAsset.hostName}"/>"><c:out value="${routerAsset.hostName}"/></option>
                                                                        </c:forEach>
                                                                    </select>
                                                                    <label for="routerAsset"></label>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2">
                                                                <button id="searchBtn" class="btn green btn-outline sbold">
                                                                    <i class="fas fa-search"></i>
                                                                    <span class="title"> <spring:message code="listNetworkAssets.search"></spring:message> </span>
                                                                    </button>
                                                                    <button id="clearBtn" class="btn blue btn-outline sbold">
                                                                        <i class="fas fa-times"></i>
                                                                        <span class="title"> <spring:message code="listNetworkAssets.clear"></spring:message> </span>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                        </br>
                                                        <div class="dataTables_wrapper no-footer">
                                                            <table id="networkAssetsDatatable" style="width: 100%;" class="table table-bordered table-hover dataTable no-footer">
                                                                <thead id="networkAssetsDatatableThead" style="width: 100%;" class="datatablesThead">
                                                                    <tr>
                                                                        <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.routerAsset"></spring:message></th>
                                                                    <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.interfaceAsset"></spring:message></th>
                                                                    <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.subnetAsset"></spring:message></th>
                                                                    <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.hostAsset"></spring:message></th>
                                                                    <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.actions"></spring:message></th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody></tbody>
                                                                <tfoot>
                                                                </tfoot>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>                        
                                        </div>
                                </sec:authorize>
                            </div>
                            <div class="tab-pane fade" id="topologySnapshotsTab">  
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="portlet  portlet-fit">
                                            <div class="portlet-title">
                                                <div class="actions">
                                                    <a onclick="deleteAllSnapshots();" class="expandableBtn btn btn-sm  red  right-aligned"> <i class="fas fa-times"></i>
                                                        <span><spring:message code="networkTopology.removeAll"></spring:message></span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="portlet-body">
                                                    <table id="displaySnapshotTable"  class="table table-striped table-bordered table-hover" cellspacing="0" width="100%">
                                                        <thead id="displaySnapshotTableThead" style="width: 100%;" class="datatablesThead">
                                                            <tr>
                                                                <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.date"/></th>
                                                            <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.routerAsset"></spring:message></th>
                                                            <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.subnetAsset"></spring:message></th>
                                                            <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.actions"></spring:message></th>
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
            </div>
            <div id="snapshotDetails" class="modal fade" role="dialog">
                <div class="modal-dialog" style="width: 90vw; background-color: white !important">
                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-body" style=" background-color: white !important;">
                            <div class="dataTables_wrapper no-footer">
                                <table id="networkAssetDatatable" class="table table-bordered table-hover dataTable no-footer">
                                    <thead>
                                        <tr>
                                            <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.routerAsset"></spring:message></th>
                                        <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.interfaceAsset"></spring:message></th>
                                        <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.subnetAsset"></spring:message></th>
                                        <th class="sorting_disabled" rowspan="1" colspan="1"><spring:message code="listNetworkAssets.hostAsset"></spring:message></th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                    <tfoot>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="fileImport" tabindex="-1" role="fileImport" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                    <form:form id="fileupload" role="form" action="${context}/topology/importNetworkAssets?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
                        <div class="modal-header">
                            <a type="button" class="close" data-dismiss="modal" aria-hidden="true"></a>
                            <h4 class="modal-title"><spring:message code="listNetworkAssets.importCSV"></spring:message></h4>
                            </div>
                            <div class="modal-body">
                                <div class="row fileupload-buttonbar">

                                    <div class="col-md-12">
                                        <!-- The fileinput-button span is used to style the file input field as button -->
                                        <div class="fileinput fileinput-new input-group" data-provides="fileinput">
                                            <div class="form-control" data-trigger="fileinput">
                                                <i class="glyphicon glyphicon-file fileinput-exists"></i> <span class="fileinput-filename"></span>
                                            </div>
                                            <span class="input-group-addon btn btn-default btn-file" style="color: #5898b6;">
                                                <span class="fileinput-new"><spring:message code="generic.selectFile"/></span>
                                            <span class="fileinput-exists"><spring:message code="generic.change"/></span>
                                            <input type="file" id="file" name="file" ></span>
                                        <a href="#" class="input-group-addon btn btn-default fileinput-exists" data-dismiss="fileinput" style="color: #D91E18;"><spring:message code="generic.remove"/></a>

                                    </div>
                                    <div id="helpMessage"></div>
                                    <!-- The global file processing state -->
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button style="width: 92px" type="button" class="btn btn-info btn-sm" id="helpBtn"><i class="fas fa-info-circle" aria-hidden="true"></i> <spring:message code="generic.help"/></button>
                            <button type="submit" class="btn btn-sm btn-primary start">
                                <span><spring:message code="importVulnerabilityFromJsonFile.submit"/></span>
                            </button>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <a class="btn btn-sm default" data-dismiss="modal" style="color: #5898b6;"><spring:message code="generic.close"/></a>
                        </div>
                    </form:form>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
    </jsp:body>
</biznet:mainPanel>