
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
    <title><spring:message code="ipReputations.title"/></title>
</head>
<biznet:mainPanel viewParams="title,search,body">
    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="ipReputations.title"/></span>
            </li>
        </ul>
    </jsp:attribute>
    <jsp:attribute name="search">
        <div class="row" style="margin-bottom: 1em;">
            <label class="col-lg-1 control-label" ><b><spring:message code="listIpReputation.value"/></b></label>
            <div class="col-lg-2">
                <input class="form-control" id ="ipSearch" name="ipSearch" >
            </div>
            <div class="col-lg-6 right" style="float:right">
                <button type="button" onClick="refreshTable()" class="btn btn-primary right" id="search" style="float:right;margin-left:0.2em"><spring:message code="generic.search"/></button>
                <button type="button" onClick="clearInDiv()" class="btn btn-info right" id="clear" style="float:right"><spring:message code="generic.clear"/></button>      
            </div>
        </div>
    </jsp:attribute>
    <jsp:attribute name="script">
         <style>      
                               
            #ipTable_processing
            {
                 margin-top: -11%;      
                 z-index: 1200;              
            }
           
        </style>     
        
        
        <script type="text/javascript">
            document.title = "<spring:message code="ipReputations.title"/> - BIZZY";
            var currentTab = "ip";
            $(document).ready(function () {
                loadIpTable();

            });
            var ipisload = false;
            var domainisload = false;
            var urlisload = false;
            function loadIpTable() {
                if (!ipisload) {
                    ipisload = true;
                    $('#ipTable').dataTable({
                        "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                        "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
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
                        "searching": false,
                        "processing": true,
                        "bLengthChange": true,
                        "bInfo": true,
                        "serverSide": true,
                        "order": [],
                        "columns": [
                            {data: "ipReputationId",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkIp" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                            },
                            {"data": 'ip'},
                            {"data": "city",
                                render: function (data, type, row) {
                                    if (data !== null) {
                                        return data;
                                    } else {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    }
                                }
                            },
                            {data: "country",
                                render: function (data, type, row) {
                                    if (data !== null) {
                                        return data;
                                    } else {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    }
                                }
                            },
                            {"data": 'createDate'},
                        ],
                        "ajax": {
                            "type": "POST",
                            "url": "loadIpReputations.json",
                            "data": function (d) {
                                d.resultId = "${resultId}",
                                        d.ip = $("#ipSearch").val(),
                                        d.type = "ip",
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
                }
            }
            function loadDomainTable() {
                if (!domainisload) {
                    domainisload = true;
                    $('#domainTable').dataTable({
                        "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                        "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
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
                        "searching": false,
                        "processing": true,
                        "bLengthChange": true,
                        "bInfo": true,
                        "serverSide": true,
                        "order": [],
                        "columns": [
                            {data: "ipReputationId",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkDomain" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                            },
                            {"data": 'ip'},
                            {data: "city",
                                render: function (data, type, row) {
                                    if (data !== null) {
                                        return data;
                                    } else {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    }
                                }
                            },
                            {data: "country",
                                render: function (data, type, row) {
                                    if (data !== null) {
                                        return data;
                                    } else {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    }
                                }
                            },
                            {"data": 'createDate'},
                        ],
                        "ajax": {
                            "type": "POST",
                            "url": "loadIpReputations.json",
                            "data": function (d) {
                                d.resultId = "${resultId}",
                                        d.ip = $("#ipSearch").val(),
                                        d.type = "domain",
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
                }
            }
            function loadUrlTable() {
                if (!urlisload) {
                    urlisload = true;
                    $('#urlTable').dataTable({
                        "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                        "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
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
                        "searching": false,
                        "processing": true,
                        "bLengthChange": true,
                        "bInfo": true,
                        "serverSide": true,
                        "order": [],
                        "columns": [
                            {data: "ipReputationId",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkUrl" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                            },
                            {"data": 'ip'},
                            {data: "city",
                                render: function (data, type, row) {
                                    if (data !== null) {
                                        return data;
                                    } else {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    }
                                }
                            },
                            {data: "country",
                                render: function (data, type, row) {
                                    if (data !== null) {
                                        return data;
                                    } else {
                                        return '<div ><i class="fas fa-minus"></i> </div>';
                                    }
                                }
                            },
                            {"data": 'createDate'},
                        ],
                        "ajax": {
                            "type": "POST",
                            "url": "loadIpReputations.json",
                            "data": function (d) {
                                d.resultId = "${resultId}",
                                        d.ip = $("#ipSearch").val(),
                                        d.type = "url",
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
                }
            }
            $('[href=#tab1default]').on('shown.bs.tab', function (e) {
                currentTab = "ip";
                loadIpTable();
                $('#ipTableThead').resize();
            });
            $('[href=#tab2default]').on('shown.bs.tab', function (e) {
                currentTab = "domain";
                loadDomainTable();
                $('#urlTableThead').resize();
            });
            $('[href=#tab3default]').on('shown.bs.tab', function (e) {
                currentTab = "url";
                loadUrlTable();
                $('#urlTableThead').resize();
            });

            function addIp() {
                $('#addIpModal').modal('show');
            }
            function checkAvailibility() {
                $.post("addIp.json", {
                    'ip': $("#ip").val(),
                    'type': $("#type").val(),
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (result) {
                    if (result === false) {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listIpReputations.sameIpMessage"/>");
                        $("#alertModal").modal("show");
                    } else {
                        var t = $("#type").val();
                        if (t === "ip" && ipisload) {
                            $("#ipTable").dataTable().api().draw();
                        } else if (t === "domain" && domainisload) {
                            $("#domainTable").dataTable().api().draw();
                        }
                        if (t === "url" && urlisload) {
                            $("#urlTable").dataTable().api().draw();
                        }
                    }
                });
            }
            function refreshTable() {
                if (currentTab === "ip")
                    $("#ipTable").dataTable().api().draw();
                else if (currentTab === "domain")
                    $("#domainTable").dataTable().api().draw();
                else if (currentTab === "url")
                    $("#urlTable").dataTable().api().draw();
            }
            function clearInDiv() {
                $("#ipSearch").val("");
            }

            function deleteAlert() {
                var alertIds = [];
                if (currentTab === "ip") {
                    $('input[id=checkIp]:checked').each(function () {
                        alertIds.push($(this).val());
                    });
                    if (alertIds.length > 0) {
                        $.post("deleteTiData.json", {
                            'type': 'ipReputation',
                            'alertIds[]': alertIds,
            ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function () {
                            $("#ipTable").dataTable().api().draw();
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                            $("#alertModal").modal("show");
                        }).always(function () {
                        });
                    } else {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listIpReputation.ipalert"/>");
                        $("#alertModal").modal("show");
                    }
                } else if (currentTab === "domain") {
                    $('input[id=checkDomain]:checked').each(function () {
                        alertIds.push($(this).val());
                    });
                    if (alertIds.length > 0) {
                        $.post("deleteTiData.json", {
                            'type': 'ipReputation',
                            'alertIds[]': alertIds,
            ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function () {
                            $("#domainTable").dataTable().api().draw();
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                            $("#alertModal").modal("show");
                        }).always(function () {
                        });
                    } else {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listIpReputation.domainalert"/>");
                        $("#alertModal").modal("show");
                    }

                } else if (currentTab === "url") {
                    $('input[id=checkUrl]:checked').each(function () {
                        alertIds.push($(this).val());
                    });
                    if (alertIds.length > 0) {
                        $.post("deleteTiData.json", {
                            'type': 'ipReputation',
                            'alertIds[]': alertIds,
            ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function () {
                            $("#urlTable").dataTable().api().draw();
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                            $("#alertModal").modal("show");
                        }).always(function () {
                        });
                    } else {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listIpReputation.urlalert"/>");
                        $("#alertModal").modal("show");
                    }

                }
            }

        </script>  
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
    </jsp:attribute>
    <jsp:attribute name="button">
        <div class="portlet-body" style="margin-top:-1.5%">
            <p>
                <a class="btn btn-primary btn-info btn-sm" onclick="addIp()" ><spring:message code="listTags.add"/></a> &nbsp;
                <a class="btn btn-primary btn-info btn-sm" onclick="deleteAlert()" ><spring:message code="generic.delete"/></a>
            </p>
        </div> 
    </jsp:attribute>
    <jsp:body>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/taskengine.min.css">
            <div>
                <div class="panel with-nav-tabs panel-default">
                    <div class="tabbable-custom nav justified" style="overflow:visible !important">
                        <ul class="nav nav-tabs nav-justified">
                            <li class="active" > <a  style="text-decoration:none;color:#428bca" href="#tab1default" data-toggle="tab"><i id="tabIp" style="font-style:inherit"><spring:message code="listIpReputation.ip"/></i></a></li>                                                                                   
                            <li><a  style="text-decoration:none;color:#428bca" href="#tab2default" data-toggle="tab"><i id="tabDomain" style="font-style:inherit"><spring:message code="listIpReputation.domain"/></i></a></li>  
                            <li><a  style="text-decoration:none;color:#428bca" href="#tab3default" data-toggle="tab"><i id="tabUrl" style="font-style:inherit"><spring:message code="listIpReputation.url"/></i></a></li>
                        </ul>
                    </div>
                    <div class="panel-body">
                        <div class="tab-content">
                            <div class="tab-pane fade in active" id="tab1default">
                                <div>
                                    <table width="100%" class="table table-striped table-bordered table-hover" id="ipTable" >
                                        <thead id="ipTableThead" class="datatablesThead">
                                            <tr>
                                                <th width="10px"><input type="checkbox" class="editor-active" id="selectAllIp" onclick="selectAll2('selectAllIp', 'checkIp');"></th>
                                            <th style="vertical-align: middle;width: 40%"><spring:message code="listIpReputation.value"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="info.city"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="info.country"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="listVulnerabilities.creationDate"/></th> 
                                            </tr>
                                            </thead>                                
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="tab2default">
                                <div>
                                    <table width="100%" class="table table-striped table-bordered table-hover" id="domainTable" >
                                        <thead id="domainTableThead" class="datatablesThead">
                                            <tr>
                                                <th width="10px"><input type="checkbox" class="editor-active" id="selectAllDomain" onclick="selectAll2('selectAllDomain', 'checkDomain');"></th>
                                            <th style="vertical-align: middle;width: 40%"><spring:message code="listIpReputation.value"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="info.city"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="info.country"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="listVulnerabilities.creationDate"/></th> 
                                            </tr>
                                            </thead>                                
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="tab3default">
                                <div>
                                    <table width="100%" class="table table-striped table-bordered table-hover" id="urlTable" >
                                        <thead id="urlTableThead" class="datatablesThead">
                                            <tr>
                                                <th width="10px"><input type="checkbox" class="editor-active" id="selectAllUrl" onclick="selectAll2('selectAllUrl', 'checkUrl');"></th>
                                            <th style="vertical-align: middle;width: 40%"><spring:message code="listIpReputation.value"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="info.city"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="info.country"/></th>
                                            <th style="vertical-align: middle;width: 20%"><spring:message code="listVulnerabilities.creationDate"/></th> 
                                            </tr>
                                            </thead>                                
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="addIpModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
                <div class="modal-dialog" style="height: 100%; overflow-x: hidden; width: 50%;"> 
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"><b><spring:message code="generic.new"/> <spring:message code="listResultAssets.ip"/></b></h4>
                        </div>
                        <div id="modalBody">
                            <div class="col-lg-12">
                                <div class="row" style="padding-top: 10px;"></div>
                                <div class="row">
                                    <div class =" col-lg-3">
                                        <label class="control-label" ><spring:message code="listIpReputation.value"/></b></label>    
                                    </div>
                                    <div class =" col-lg-9">
                                        <input class="form-control" id="ip"  placeholder="">   
                                    </div>
                                </div>
                                <div class="row" style="padding-top: 10px;"></div>
                                <div class="row">
                                    <div class =" col-lg-3">
                                        <label class="control-label" ><b><spring:message code="viewQualysReport.type"/></b></label>    
                                    </div>
                                    <div class =" col-lg-9">
                                        <select id="type" name="type" class="js-example-basic js-states form-control" style="width: 100%;">
                                            <option value="ip"><spring:message code="listIpReputation.ip"/></option>
                                            <option value="domain"><spring:message code="listIpReputation.domain"/></option>
                                            <option value="url"><spring:message code="listIpReputation.url"/></option>
                                        </select>   
                                    </div>
                                </div>
                                <div class="row" style="padding-top: 10px;"></div>
                            </div>
                            <div class="modal-footer"> 
                                <br>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="checkAvailibility()"><spring:message code="listTags.add"/></button> 

                                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="listTags.cancel"/></button> 
                            </div> 
                        </div> 
                    </div> 
                </div>
            </div>
            <style>
                .dataTables_length {
                    margin-top: 0px !important;
                    display: inline;
                    position: relative;
                    float: right;
                    z-index: 2;
                }
                .dataTables_wrapper{
                    margin-top: -10px;
                }
            </style>
        </jsp:body>
    </biznet:mainPanel>

</html>
