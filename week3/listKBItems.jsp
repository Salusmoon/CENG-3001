<%-- 
    Document   : listKBItems
    Created on : Aug 26, 2014, 4:12:40 PM
    Author     : aidikut
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<biznet:mainPanel viewParams ="title,search,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listKBItems.vulnerabilities"/></span>
            </li>
        </ul>

    </jsp:attribute>

    <jsp:attribute name="search">

        <biznet:searchpanel tableName="oTable">
            <jsp:body>

                <div class="row" style="margin-bottom: 1em;margin-left: 1px;">
                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.riskLevel"/></b></label>
                    <div class="col-lg-2">
                        <select id="riskLevels" name="riskLevels" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                            <option value="5"><spring:message code="searchPanel.RiskLevel5"/></option>
                            <option value="4"><spring:message code="searchPanel.RiskLevel4"/></option>
                            <option value="3"><spring:message code="searchPanel.RiskLevel3"/></option>
                            <option value="2"><spring:message code="searchPanel.RiskLevel2"/></option>
                            <option value="1"><spring:message code="searchPanel.RiskLevel1"/></option>
                            <option value="0"><spring:message code="searchPanel.RiskLevel0"/></option>
                        </select>
                    </div>

                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.vName"/></b></label>
                    <div class="col-lg-2">
                        <input class="form-control" id="name" name="vulnName"  placeholder="">
                    </div>

                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.category"/></b></label>
                    <div class="col-lg-2">
                        <select id="category" name="categories" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                            <c:forEach items="${categories}" var="category">
                                <option value="<c:out value="${category.id}"/>">
                                    <c:choose>
                                        <c:when test="${selectedLanguage == 'en'}">
                                            <c:out value="${category.secondaryName}"/>
                                        </c:when>
                                        <c:when test="${selectedLanguage == 'tr'}">
                                            <c:out value="${category.name}"/>
                                        </c:when>                      
                                    </c:choose></option>
                            </c:forEach>
                        </select>
                    </div>

                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.problemArea"/></b></label>
                    <div class="col-lg-2">
                        <select id="problemArea" name="problemArea" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                            <c:forEach items="${problemAreas}" var="problemArea">
                                <option value="<c:out value="${problemArea.name}"/>"><c:out value="${problemArea.value}"/></option>
                            </c:forEach>
                        </select>
                    </div>



                </div>
                <div class="row" style="margin-bottom: 1em;margin-left: 1px">


                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.rootCause"/></b></label>
                    <div class="col-lg-2">
                        <select id="rootCause" name="rootCause" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                            <c:forEach items="${rootCauses}" var="cause">
                                <option value="<c:out value="${cause.name}"/>"><c:out value="${cause.value}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.labels"/></b></label>
                    <div class="col-lg-2">
                        <select id="labels" name="labels" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                            <c:forEach items="${labelList}" var="label">
                                <option value="<c:out value="${label.name}"/>"><c:out value="${label.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.effect"/></b></label>
                    <div class="col-lg-2">
                        <select id="effect" name="effect" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                            <c:forEach items="${effects}" var="effect">
                                <option value="<c:out value="${effect.name}"/>"><c:out value="${effect.value}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <label class="col-lg-1 control-label" ><b><spring:message code="addVulnerability.cveId"/></b></label>
                    <div class="col-lg-2">
                        <input class="form-control" id="cveName" name="cves"  placeholder="">
                    </div>
                </div>


            </jsp:body>
        </biznet:searchpanel>

    </jsp:attribute>

    <jsp:attribute name="button">

        <sec:authorize access="hasAnyRole('ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">
            <div class="btn-group" style="margin-left: 7px">
                <a class="btn btn-primary btn-sm"   href="addKBItem.htm"><spring:message code="listKBItems.addKBItem"/></a>   
            </div>
                
            <div class="btn-group">
                <a class="btn btn-sm btn-default btn-success dropdown-toggle" data-toggle="dropdown" href="javascript:;" aria-expanded="false"> 
                    <spring:message code="listVulnerabilities.actions"/>
                    <i class="fas fa-angle-down"></i>
                </a>
                <ul class="dropdown-menu">    
                    <li>
                        <a onclick="showActionModals('4')"> <spring:message code="listVulnerabilities.updateVulnerabilities"/> </a>
                    </li>
                     <sec:authorize access="hasAnyRole('ROLE_PENTEST_ADMIN')">
                    <li>
                        <a onclick="exportKbItems()"><spring:message code="listScans.pentestExport"/></a>
                    </li>
                     </sec:authorize>
                </ul>
            </div>
        </sec:authorize>

    </jsp:attribute>

    <jsp:attribute name="alert">

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <spring:message code="${error}"></spring:message>
                </div>
        </c:if>    

    </jsp:attribute> 

    <jsp:attribute name="script">

        <script type="text/javascript">
            document.title = "<spring:message code="listKBItems.vulnerabilities"/> - BIZZY";
            var category = [];
            category.push("${custom:escapeForJavascript(categoryId)}");
            $("#category").val(category).trigger("change");
            $("[data-toggle=popover]").popover();
            if("${custom:escapeForJavascript(categoryId)}" !== "") {
                $("#searchPanelLink").attr("class","expand");
                $("#searchPanelLink").attr("data-toggle","expand");
                $("#collapseSearch").css("display","block");
            }
            var labelsAndColors = [];
            var labelsList = [];
            var colors = [];
            for (var t = 0; t < 50; t++) {
                colors.push("default");
                colors.push("info");
                colors.push("success");
                colors.push("warning");
                colors.push("primary");
                colors.push("danger");
            }
            <c:forEach var="item" items="${labelList}">
            labelsAndColors.push('<h4><span class="label label-' + colors.pop() + '">' + '<c:out value="${item.name}"/>' + '</span></h4>');
            labelsList.push(decodeHtml('<c:out value="${item.name}"/>'));
            </c:forEach>
            var oTable;

            $("#clear").click(function () {
                $("#ipAddress").val("");
                $("#port").val("");
                $("#riskLevels").val(null).trigger("change");
                $("#category").val(null).trigger("change");
                $("#problemArea").val(null).trigger("change");
                $("#effect").val(null).trigger("change");
                $("#rootCause").val(null).trigger("change");
                $("#labels").val(null).trigger("change");
                $("#name").val("");
                //TODO: Grup ve Etiket alanları da temizlenmeli
                $("#add_time").val("");
                $("#responsible").val("");
                $("#daterange").val("");
            });

            $(document).ready(function () {

                oTable = $('#serverDatatables').dataTable({
                    "dom": "<'row'<'col-sm-6'f><'col-sm-6'l>>rtip",
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "bFilter": false,
                    "scrollX": true,
                    "language": {
                        "processing": "<spring:message code="generic.tableLoading"/>",
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
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
                            data: "id",
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkKbItem" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            "data": function (data, type, dataToSet) {
                                var name = "";
                                if (data.newItem) {
                                    name += '<span class="badge badge-danger"><spring:message code="generic.new"/></span> ';
                                }
                                if (data.matched) {
                                    name += '<i class="fas fa-exchange-alt" style="font-size:20px"></i> ';
                                }
                                <c:choose>
                                        <c:when test="${selectedLanguage == 'en'}">
                                            if(data.kbItemDescription.otherLanguageNames.en !== null){
                                                return name + data.kbItemDescription.otherLanguageNames.en;
                                            } else
                                                return '<div ><i class="fas fa-minus"></i> </div>';
                                            
                                        </c:when>
                                        <c:when test="${selectedLanguage == 'tr'}">
                                            return name + data.kbItemDescription.name;
                                        </c:when>                      
                                </c:choose>
                            },
                            "orderData": [9]
                        },
                        {"data": 'effect',
                            "render": function (data) {
                                if (data !== null && data !== "") {
                                    return data;
                                } else {
                                    return '<div ><i class="fas fa-minus"></i> </div>';
                                }
                            }
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.labels !== null || data.labels.length !== 0) {
                                    var labels = "";
                                    for (var i = 0; i < data.labels.length; i++) {
                                        for (var j = 0; j < labelsList.length; j++) {
                                            var value = "'>' + decodeHtml(data.labels[i].name) + '<'";
                                            if (decodeHtml(data.labels[i].name) === labelsList[j] && labels.indexOf(value) === -1) {
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
                            "orderable": false
                        },
                                    <c:choose>
                                        <c:when test="${selectedLanguage == 'en'}">
                                            {"data": 'category.secondaryName'},
                                        </c:when>
                                        <c:when test="${selectedLanguage == 'tr'}">
                                            {"data": 'category.name'},
                                        </c:when>                      
                                    </c:choose>
                        {"data": function (data, type) {
                                let levelStr = '<div >' + data.riskLevel + ' (' + data.riskDescription + ')' + ' </div>';
                                switch (data.riskLevel) {
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
                            "orderData": [12]
                        
                        },
                                
                        {"data": 'updateDate',
                                    "render": function (data) {
                                        if (data !== null && data !== "") {
                                            return data;
                                        } else {
                                            return '<div ><i class="fas fa-minus"></i> </div>';
                                        }
                                    }   
                        },
                        {"data": 'updateUser.username',
                                "render": function (data) {
                                if (data !== null && data !== "") {
                                    return data;
                                } else {
                                    return '<div ><i class="fas fa-minus"></i> </div>';
                                }
                            }
                        },
                        {"data": 'creationDate'},
                        {"data": 'user.username'},
                        {
                            "data": 'id',
                            "render": function (data) {
                                var html = '<div class="dropdown"><button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                                html += '<li style="list-style: none;"><a  href="viewKBItem.htm?kbItemId=' + data + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail"/></a></li>  ';
            <sec:authorize access="hasAnyRole('ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">
                                html += '<li style="list-style: none;"><a  href="addKBItem.htm?action=update&kbItemId=' + data + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.edit"/></a></li>  ';
                                html += '<li style="list-style: none;"><a  onClick="deleteRow(\'' + data + '\', this)" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a></li>  ';
            </sec:authorize>
                                html += '</ul></div>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'kbItemDescription.name',
                            "visible": false
                        },
                        {"data": 'riskLevel',
                            "visible": false
                        }
                    ],
                    "order": [6, 'desc'],
                    "ajax": {
                        "type": "POST",
                        "url": "loadKBItems.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
                            d.categoryId = $("#category").val();
                            d.labels = $("#labels").val();
                            d.riskLevels = $('#riskLevels').val();
                            d.name = $('#name').val();
                            d.effect = $('#effect').val();
                            d.rootCause = $('#rootCause').val();
                            d.problemArea = $('#problemArea').val();
                            d.category = $("#category").val();
                            d.cveIdList = $("#cveName").val();
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                        }
                    },
                    "initComplete": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    },
                    "fnDrawCallback": function (oSettings) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
                    }

                });
            });

            function deleteRow(id, deletedElement) {


                function confirmDelete() {

                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteKBItem.json", {kbItemId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        oTable.fnDeleteRow(nRow);
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listKBItems.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });

                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listKBItems.confirmDelete"/>"), confirmDelete);

            }
            
            function allRecordsFunction() {
                if ($('#selectAll').is(":checked")) {
                    $('#allRecords').show();
                } else {
                    $('#allRecords').hide();
                    $("#checkBoxAllRecords").prop('checked', false);
                }
            }
            
            function showActionModals(option) {
                $('#multiKBParametersChangeModal').modal();
            }
            
            function createFilterData() {
                return $("#searchForm").serializeArray();
            }
            
            function exportKbItems(){
                var vulIds = new Array();
                loadDataByTabForParameters(vulIds);
                var arrayString = '?vulnIds=';
                $.each(vulIds, function (key, value) {
                    arrayString += value + ',';
                });
                arrayString = arrayString.substring(0, arrayString.length - 1);
                var url = 'getJsonReportForSelectedKbItems.htm' + arrayString;
                window.location.href = encodeURI(url);
            }
            
        </script>     
<jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
    </jsp:attribute>         

    <jsp:body>
        <div id="allRecords" style ="display: none">
                                        <input type="checkbox" class="editor-active" id="checkBoxAllRecords">
                                            <spring:message code="generic.checkAllRecordsText"/>   
                                    </div>
        <div style="margin-left: 6px">
            <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" style="width: 100%;">
                <thead class="datatablesThead">
                    <tr>  
                        <th width="10px"><input type="checkbox" class="editor-active" id="selectAll" onclick="allRecordsFunction();
                                                                    selectAll('checkKbItem');" ></th>
                        <th><spring:message code="listKBItems.name"/></th>
                        <th><spring:message code="listKBItems.effect"/></th>
                        <th><spring:message code="viewVulnerability.labels"/></th>
                        <th><spring:message code="listKBItems.category"/></th>
                        <th style="vertical-align: middle; min-width: 100px;" width="100px"><spring:message code="listKBItems.riskLevel"/></th>
                        <th style="min-width: 130px;" width="130px" ><spring:message code="kbItemList.updateColumn"/></th>
                        <th><spring:message code="listKBItems.updateBy"/></th>
                        <th style="min-width: 130px;" width="130px" ><spring:message code="listKBItems.creationDate"/></th>
                        <th><spring:message code="listKBItems.addedBy"/></th>
                        <th width="103px"><div style="min-width: 103px;" ></div></th>
                    </tr>
                </thead>                                
            </table>  
        </div>
                        <jsp:include page="include/multiKBParametersChangeModal.jsp" >
                            <jsp:param name="type" value="vulnerability"/>  
                        </jsp:include>
        <style>
            .popover{
                min-width: 200px;
            }
            .tooltip-inner {
                white-space: pre-wrap;
            }
            .dataTables_length {
                  margin-top: 0px !important;
                  display: inline;
                  position: relative;
                  float: right;
                  z-index: 2;
            }
            .dataTables_wrapper{
                    margin-top: -50px;
            }
        </style>
    </jsp:body>

</biznet:mainPanel>