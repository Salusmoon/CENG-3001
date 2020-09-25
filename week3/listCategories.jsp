<%-- 
    Document   : listCategories
    Created on : Aug 27, 2014, 10:54:46 AM
    Author     : aidikut
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>

<biznet:mainPanel viewParams="title,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listCategories.title"/></span>
            </li>
        </ul>

    </jsp:attribute>

    <jsp:attribute name="button">

        <p>
            <div class="dt-buttons">
                <sec:authorize access="hasAnyRole('ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER,ROLE_PENTEST_USER')">
                    <a class="btn btn-primary btn-sm" href="addCategory.htm"><spring:message code="listCategories.addCategory"/></a>    
                      <a class="btn btn-primary btn-sm" onclick="deleteAlert()" ><spring:message code="networkTopology.removeAll"/></a>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('ROLE_PENTEST_ADMIN')">
                    <a class="btn btn-success btn-sm" onclick="jsonReport()"><spring:message code="listCategories.jsonReport"/></a> 
                    <a class="btn btn-warning btn-sm" onclick="importJsonReport()"><spring:message code="listCategories.importjsonReport"/></a> 
                </sec:authorize>
            </div>
        </p>

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
            document.title = "<spring:message code="main.theme.listCategories"/> - BIZZY";
            $('.dropdown-toggle').on('click', function (){
                console.log("deneme");
                setTimeout(function(){
                    $('#serverDatatables').DataTable().columns.adjust().draw();       
                }, 300);  
            });
            var oTable;
            $("[data-toggle=popover]").popover();
            $(document).ready(function () {
            oTable = $('#serverDatatables').dataTable({
                    "dom": "<'row'<'col-sm-10'f><'col-sm-2'l>>rtip",
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "stateSave": true,
                    "scrollX": true,
                    "language": {
                    "processing": "<spring:message code="generic.tableLoading"/>",
                            "search": "<spring:message code="generic.search"/>  ",
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
                    {data: "id",
                                render: function (data, type, row) {
                                    return '<input type="checkbox" class="editor-active" id="checkCategory" value="' + data + '" >';
                                },
                                className: "dt-body-center",
                                "searchable": false,
                                "orderable": false
                            },
            <c:choose>
                <c:when test = "${currentLanguage == 'tr'}">
                    {"data": 'name'},
                </c:when>
                <c:otherwise>
                    {"data": 'secondaryName'},
                </c:otherwise>
            </c:choose>
                    {"data": 'creationDate'},
                    {"data": 'createdBy.username', "defaultContent": ''},
                    {"data": 'lastUpdateDate'},
                    {"data": 'updatedBy.username', "defaultContent": ''},
                    {
                    "data": 'id',
                            "render": function (data) {
                                var html = '<div class="dropdown"><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';    
                                html += '<li style="list-style: none;"><a  href="listKBItems.htm?categoryId=' + data + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.vulnerabilities"/></a></li>  ';
                            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasAnyRole('ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER')">
                                html += '<li style="list-style: none;"><a  href="addCategory.htm?action=update&categoryId=' + data + '" data-toggle="tooltip" data-placement="top"><spring:message code="generic.detail.edit"/></a></li>  ';
                            </sec:authorize>
                            <sec:authorize access="hasAnyRole('ROLE_PENTEST_ADMIN, ROLE_COMPANY_MANAGER')">
                                html += '<li style="list-style: none;"><a  onClick="deleteRow(\'' + data + '\', this)" data-toggle="tooltip" data-placement="top"><spring:message code="generic.delete"/></a></li>  ';
                            </sec:authorize>
                                html += '</ul></div>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                    }
                    ],
                    "order": [0, 'asc'],
                    "ajax": {
                    "type": "POST",
                            "url": "loadCategories.json",
                            "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
                            },
                            // error callback to handle error
                            "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listCategories.tableError"/>");
                            $("#alertModal").modal("show");
                            }
                    },
                    "initComplete": function(settings, json) {
                    $('[data-toggle="tooltip"]').tooltip();
                    $("[data-toggle=popover]").popover();
                    },
                    "fnDrawCallback": function (oSettings) {
                    $('[data-toggle="tooltip"]').tooltip();
                    $("[data-toggle=popover]").popover();
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
                    }).attr("placeholder", "<spring:message code="listCategories.searchTip" htmlEscape="false"/>").width('220px');
            });
            function deleteRow(id, deletedElement) {

            function confirmDelete(){
            var nRow = $(deletedElement).parents('tr')[0];
            $.post("deleteCategory.json", {categoryId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
            }).done(function () {
                
            oTable.fnDeleteRow(nRow);
            
            }).fail(function () {
            $("#alertModalBody").empty();
            $("#alertModalBody").html("<spring:message code="listCategories.deleteFail"/>");
            $("#alertModal").modal("show");
            }).always(function () {
            });
            }
            jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listCategories.confirmDelete"/>"), confirmDelete);
            }

            function jsonReport() {
                $("#jsonReportTypeModal").modal("show");
            }
            function closeModal(){
                $("#jsonReportTypeModal").modal("hide");
            }
            function jsonReportConfirm() {
            var type = $('#exportType').val();
            var url = 'getJsonReport.htm?type=' + type;
            //  Javascript Url encoding fonksiyonunu kullandık.
            window.location.href = encodeURI(url);
            }

            function importJsonReport() {
            window.location = "../kb/importJsonReport.htm";
            }
            
            var node = document.getElementsByClassName('info')[i];
            node.parentNode.removeChild(node);
            
              function deleteAlert() {
                var categoryIds = [];
                    $('input[id=checkCategory]:checked').each(function () {
                        categoryIds.push($(this).val());
                    });
                    
                    if (categoryIds.length > 0) {
                        $.post("deleteCategoryData.json", {
                            'type': 'Category',
                            'categoryIds[]': categoryIds,
            ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                        }).done(function () {
                            $("#serverDatatables").dataTable().api().draw();
                        }).fail(function () {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                            $("#alertModal").modal("show");
                        }).always(function () {
                        });
                    } else {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listCategories.categoryalert"/>");
                        $("#alertModal").modal("show");
                    }
                
            }
            
         
 

        </script>
<jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
    </jsp:attribute>

    <jsp:body>

        <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" style="width: 100%;">
            <thead class="datatablesThead">
                <tr>
                     <th width="10px"><input type="checkbox" class="editor-active" id="selectAllCategory" onclick="selectAll2('selectAllCategory', 'checkCategory');"></th>
                    <th><spring:message code="listCategories.categoryName"/></th>
                    <th><spring:message code="listCategories.creationDate"/></th>    
                    <th><spring:message code="listCategories.addedBy"/></th>    
                    <th><spring:message code="listCategories.lastUpdate"/></th>    
                    <th><spring:message code="listCategories.updatedBy"/></th>    
                    <th width="108px"> <div style="min-width: 108px;"></div> </th>
                </tr>
            </thead>                               
        </table>  
            <div class="modal fade" id="jsonReportTypeModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
                <div class="modal-dialog" style="height: 100%; overflow-x: hidden; width: 25%;"> 
                    <div class="modal-content">
                        <div class="modal-header">
                            <div id = "modal-header"><spring:message code="listCategories.jsonReport"/></div>
                        </div>
                        <div id="modalBody">
                            <div class="col-lg-12">
                                <div class="row" style="padding-top: 10px;"></div>
                                    <div class="form-group">
                                        <p>
                                            <label><spring:message code="report.reportType"/>&nbsp;&nbsp;</label> 
                                            <select id ="exportType" name="exportType" class="js-example-basic-multiple js-states form-control" style="width: 100%">
                                                <option value=all selected><spring:message code="listCategories.fullExport"/></option>
                                                <option value=category><spring:message code="listCategories.categoryExport"/></option>
                                            </select>
                                        </p>
                                    </div>
                                <div class="row" style="padding-top: 10px;"></div>
                            </div>
                            <div class="modal-footer"> 
                                <br>
                                <button type="button" id="submitForm" onclick="jsonReportConfirm()" class="btn btn-success success" data-dismiss="modal"><spring:message code="listScans.rescanStart"/></button> 
                                <button type="button" class="btn btn-default" onclick="closeModal()" data-dismiss="modal"><spring:message code="listTags.cancel"/></button> 
                            </div>
                        </div> 
                    </div> 
                </div>
            </div>
            <style>
                .dt-buttons {
                    float: none !important;
                    margin-top: 0% !important;
                    display: inline;
                    z-index: 2;  
                } 
                .dataTables_length {
                    margin-top: 4px !important;
                    display: inline;
                    position: relative;
                    left: 28%;
                    z-index: 2;
                }
                .dataTables_filter{
                    position: relative;
                    left: 6%;
                }
                .dataTables_wrapper {
                    margin-top: -50px;
                }
                .dataTables_deletebutton{
                    position: relative;
                }
            </style>

    </jsp:body>

</biznet:mainPanel>