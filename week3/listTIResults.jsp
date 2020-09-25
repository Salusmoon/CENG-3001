<%-- 
    Document   : listTIResults
    Created on : 24-Jul-2019, 14:18:01
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="listTIResults.title"/></title>
    </head>
    <biznet:mainPanel viewParams="title,search,body">
        <jsp:attribute name="title">
            <ul class="page-breadcrumb breadcrumb"> <li>
                    <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                    <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                </li>
                <li>
                    <span class="title2"><spring:message code="listTIResults.title"/></span>
                </li>
            </ul>
        </jsp:attribute>
        <jsp:attribute name="search">
            <biznet:searchpanel tableName="oTable">
                <jsp:body>
                    <div class="col-lg-12" style="left:-1%;">
                        <div class="col-lg-3">
                            <div class="col-lg-4">
                                <label class="control-label" id="resultValue" ><b><spring:message code="listTIResults.value"/></b></label>
                            </div>
                            <div class="col-lg-8">
                                <input class="form-control" id="resultValue" name="resultValue" placeholder="">
                            </div>       
                        </div>    

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
                            
                    </div> 
                </jsp:body>
            </biznet:searchpanel>

        </jsp:attribute>
        <jsp:attribute name="script">
            
            <style>      
                               
            #ipTable_processing
            {
                 margin-top: -4.5%;      
                 z-index: 1200;              
            }
           
            </style>     
            
            <script type="text/javascript">
                document.title = "<spring:message code="listTIResults.title"/> - BIZZY";
                var filterTypes = [];
                <c:forEach var="item" items="${filterTypes}">
                filterTypes.push(decodeHtml('<c:out value="${item}"/>'));
                </c:forEach>
                $('#resultType').val(filterTypes).trigger("change");
                $(function () {
                $('#daterange').daterangepicker({
                autoUpdateInput: false,
                        locale:  <c:choose>
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
                $(document).ready(function () {
                loadIpTable();

                });
                
                function refreshTable() {
                if (currentTab === "ip")
                    $("#ipTable").dataTable().api().draw();
                else if (currentTab === "hostname")
                    $("#hostnameTable").dataTable().api().draw();
                else if (currentTab === "url")
                    $("#urlTable").dataTable().api().draw();
                
                 else if (currentTab === "email")
                    $("#emailTable").dataTable().api().draw();
                }
                
               
                
               
                
                
                var currentTab="ip";
                $('[href=#tab1default]').on('shown.bs.tab', function (e) {
                currentTab = "ip";
                loadIpTable();
                $('#ipTableThead').resize();
                });
                $('[href=#tab2default]').on('shown.bs.tab', function (e) {
                currentTab = "url";
                loadUrlTable();
                $('#urlTableThead').resize();
                });
                $('[href=#tab3default]').on('shown.bs.tab', function (e) {
                currentTab = "hostname";
                loadHostnameTable();
                $('#hostnameTableThead').resize();
                });
                $('[href=#tab4default]').on('shown.bs.tab', function (e) {
                currentTab = "email";
                loadEmailTable();
                $('#emailTableThead').resize();
                });
                var ipisload = false;
                var urlisload = false;
                var hostnameisload = false;
                var emailisload = false;
                function loadIpTable() {
                    if (!ipisload) {
                        ipisload = true;
                       $('#ipTable').dataTable({
                            "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                            "scrollX": true,
                            "processing": true,
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
                            "order": [2, "desc"],
                            "columns": [
                               {"data": "id",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkIp" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                                },
                                {"data": 'value'},
                                {"data": 'createDate'}
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadTIResults.json",
                                "data": function (obj) {
                                    var tempObj = getObjectByForm("searchForm");
                                    tempObj.resultType="IP";
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
                            "order": [2, "desc"],
                            "columns": [
                               {"data": "id",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkUrl" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                                },
                                {"data": 'value'},
                                {"data": 'createDate'}
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadTIResults.json",
                                "data": function (obj) {
                                    var tempObj = getObjectByForm("searchForm");
                                    tempObj.resultType="URL";
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
                            
                        });
                    }
                    }
                    function loadHostnameTable() {
                    if (!hostnameisload) {
                        hostnameisload = true;
                        $('#hostnameTable').dataTable({
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
                            "order": [2, "desc"],
                            "columns": [
                                {"data": "id",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkHostname" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                                },
                                {"data": 'value'},
                                {"data": 'createDate'}
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadTIResults.json",
                                "data": function (obj) {
                                    var tempObj = getObjectByForm("searchForm");
                                    tempObj.resultType="HOSTNAME"
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

                            }
                        });
                    }
                    }
                    function loadEmailTable() {
                    if (!emailisload) {
                        emailisload = true;
                        $('#emailTable').dataTable({
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
                            "order": [2, "desc"],
                            "columns": [
                                {"data": "id",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkEmail" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                                },
                                {"data": 'value'},
                                {"data": 'createDate'}
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadTIResults.json",
                                "data": function (obj) {
                                    var tempObj = getObjectByForm("searchForm");
                                    tempObj.resultType="EMAIL";
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

                            }
                        });
                    }
                    }
            </script> 
            <style>
                .popover{
                    min-width: 470px;
                }
                .modal-body, .modal-content {
                    width:  800px;

                }
            </style>
            <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        </jsp:attribute>
        <jsp:body>
            <div>
                <div class="panel with-nav-tabs panel-default">
                    <div class="tabbable-custom nav justified" style="overflow:visible !important">
                        <ul class="nav nav-tabs nav-justified">
                            <li class="active" > <a  style="text-decoration:none;color:#428bca" href="#tab1default" data-toggle="tab"><i id="tabIp" style="font-style:inherit"><spring:message code="listIpReputation.ip"/></i></a></li>                                                                                   
                            <li><a  style="text-decoration:none;color:#428bca" href="#tab2default" data-toggle="tab"><i id="tabUrl" style="font-style:inherit"><spring:message code="listIpReputation.url"/></i></a></li>  
                            <li><a  style="text-decoration:none;color:#428bca" href="#tab3default" data-toggle="tab"><i id="tabHostname" style="font-style:inherit"><spring:message code="viewAssetHistory.hostname"/></i></a></li>
                            <li><a  style="text-decoration:none;color:#428bca" href="#tab4default" data-toggle="tab"><i id="tabEmail" style="font-style:inherit"><spring:message code="addBank.email"/></i></a></li>
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
                                            <th style="vertical-align: middle;"><spring:message code="listTIResults.value"/></th>     
                                            <th style="vertical-align: middle;"><spring:message code="listTIResults.createDate"/></th> 
                                            </tr>
                                            </thead>                                
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="tab2default">
                                <div>
                                    <table width="100%" class="table table-striped table-bordered table-hover" id="urlTable" >
                                        <thead id="urlTableThead" class="datatablesThead">
                                            <tr>
                                                <th width="10px"><input type="checkbox" class="editor-active" id="selectAllUrl" onclick="selectAll2('selectAllUrl', 'checkUrl');"></th>
                                           <th style="vertical-align: middle;"><spring:message code="listTIResults.value"/></th>     
                                            <th style="vertical-align: middle;"><spring:message code="listTIResults.createDate"/></th> 
                                            </tr>
                                            </thead>                                
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="tab3default">
                                <div>
                                    <table width="100%" class="table table-striped table-bordered table-hover" id="hostnameTable" >
                                        <thead id="hostnameTableThead" class="datatablesThead">
                                            <tr>
                                            <th width="10px"><input type="checkbox" class="editor-active" id="selectAllHostname" onclick="selectAll2('selectAllHostname', 'checkHostname');"></th>
                                            <th style="vertical-align: middle;"><spring:message code="listTIResults.value"/></th>     
                                            <th style="vertical-align: middle;"><spring:message code="listTIResults.createDate"/></th>  
                                            </tr>
                                            </thead>                                
                                    </table>
                                </div>
                            </div>
                             <div class="tab-pane fade" id="tab4default">
                                <div>
                                    <table id="emailTable" width="100%" class="table table-striped table-bordered table-hover">
                                        <thead id="emailTableThead" class="datatablesThead">
                                            <tr>
                                                <th width="10px"><input type="checkbox" class="editor-active" id="selectAllEmail" onclick="selectAll2('selectAllEmail', 'checkEmail');"></th>
                                                <th style="vertical-align: middle;"><spring:message code="listTIResults.value"/></th>     
                                                <th style="vertical-align: middle;"><spring:message code="listTIResults.createDate"/></th>  
                                            </tr>
                                        </thead>                                
                                    </table>
                                </div>
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
            </style>
        </jsp:body>
    </biznet:mainPanel>
</html>
