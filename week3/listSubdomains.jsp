<%-- 
    Document   : listSubdomains
    Created on : 21-Oct-2019, 17:52:45
    Author     : adem.dilbaz
--%>

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
        <title><spring:message code="subdomains.title"/></title>
    </head>
    <biznet:mainPanel viewParams="title,body">
        <jsp:attribute name="title">
            <ul class="page-breadcrumb breadcrumb"> <li>
                    <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                    <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                </li>
                <li>
                    <span class="title2"><spring:message code="subdomains.title"/></span>
                </li>
            </ul>


        </jsp:attribute>
        <jsp:attribute name="script">
            <script type="text/javascript">
                document.title = "<spring:message code="subdomains.title"/> - BIZZY";
                var oTable;
                oTable = $('#serverDatatables').dataTable({
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
                    "order": [],
                    "columns": [
                        {data: "subdomainAlertResultId",
                            render: function (data, type, row) {
                                return '<input type="checkbox" class="editor-active" id="checkSubdomainAlerts" value="' + data + '" >';
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'subdomain'},
                        {"data": 'createDate'}
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadSubdomainResults.json",
                        "data": function (d) {
                            d.resultId = "${resultId}",
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
                
                function deleteAlert() {
                    var alertIds = [];
                    $('input[id=checkSubdomainAlerts]:checked').each(function () {
                        alertIds.push($(this).val());
                    });
                    $.post("deleteTiData.json", {
                        'type': 'subdomain',
                        'alertIds[]': alertIds,
                            ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        oTable.api().ajax.reload();
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listScans.confirmAlertUnsuccessful"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });
                }

            </script>  
              <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        </jsp:attribute>
        <jsp:attribute name="button">
            <div class="portlet-body" style="margin-top:-2%">
                <p>
                    <a class="btn btn-primary btn-info btn-sm" onclick="deleteAlert()" ><spring:message code="generic.delete"/></a>
                </p> 
            </div>
        </jsp:attribute>
        <jsp:body>
            <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                <thead class="datatablesThead">
                    <tr>
                        <th width="10px"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('checkSubdomainAlerts');"></th>
                        <th style="vertical-align: middle;"><spring:message code="listSubdomains.subdomain"/></th>
                        <th style="vertical-align: middle;"><spring:message code="listVulnerabilities.creationDate"/></th>     
                    </tr>
                </thead>                                
            </table>
            <style>
                .dataTables_length {
                    margin-top: 0px !important;
                    display: inline;
                    position: relative;
                    float: right;
                    z-index: 2;
                }
                .dataTables_wrapper{
                   margin-top: -48px;
                }
            </style>
        </jsp:body>
    </biznet:mainPanel>
</body>
</html>
