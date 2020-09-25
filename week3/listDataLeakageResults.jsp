<%-- 
    Document   : listDataLeakageResults
    Created on : 02.Tem.2018, 15:42:03
    Author     : ismail.okutucu
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
        <title><spring:message code="dataLeakage.title"/></title>
    </head>
    <body>
        <biznet:mainPanel viewParams="title,body">
            <jsp:attribute name="title">
                <ul class="page-breadcrumb breadcrumb"> <li>
                        <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                        <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                    </li>
                    <li>
                        <span class="title2"><spring:message code="dataLeakage.title"/></span>
                    </li>
                </ul>


            </jsp:attribute>
            <jsp:attribute name="script">
                <script type="text/javascript">
                    document.title = "<spring:message code="dataLeakage.title"/> - BIZZY";
                    var oTable;
                    $(document).ready(function () {
                        oTable = $('#serverDatatables').DataTable({
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
                            "columnDefs": [ {
                                "targets": 4,
                                "data": null,
                                "defaultContent": '<button type="button" class="btn btn-danger btn-sm"data-toggle="tooltip" data-placement="top" title="<spring:message code="listPhishingResults.createTicket"/>"><i class="far fa-calendar"></i></button>'
                            } ],
                            "processing": true,
                            "searching": false,
                            "bLengthChange": true,
                            "bInfo": true,
                            "serverSide": true,
                            "order": [],
                            "columns": [
                                {data: "dataLeakageResultId",
                                    render: function (data, type, row) {
                                        return '<input type="checkbox" class="editor-active" id="checkDataLeakageAlerts" value="' + data + '" >';
                                    },
                                    className: "dt-body-center",
                                    "searchable": false,
                                    "orderable": false
                                },
                                {"data": 'dataLeakageName'},
                                {
                                    "name": 'listKeywords',
                                    "data": function (data, type, row, meta) {
                                        return listKeywords(data, meta.row);
                                    },
                                    "defaultContent": '',
                                    "sortable": false
                                },
                                {"data": 'createDate'}
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadDataLeakageResults.json",
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
                            "drawCallback": function (settings, json) {
                                $('[data-toggle="tooltip"]').tooltip();
                                $('[data-toggle="popover"]').popover({
                                    placement: 'top',
                                    offset: 3,
                                    trigger: "hover focus"
                                });
                            }
                        });
                        $('#serverDatatables tbody').on( 'click', 'button', function () {
                            var row = $(this).closest("tr");
                            var table = row.closest('table').dataTable();
                            var rowData = table.api().row( row ).data();
                            var alertName = <c:out value = "rowData.dataLeakageName"/>;
                            var createDate = <c:out value = "rowData.createDate"/>;
                            var keywords = <c:out value = "rowData.keywords"/>;
                            var descStr = "";
                            descStr += "<spring:message code="ti.alertName"/>: "+alertName+"\n";
                            var processingKeyword = "";
                            for (i = 0; i < rowData.dataLeakageUrlResult.length; ++i) {
                                processingKeyword = rowData.dataLeakageUrlResult[i].keyword;
                            }
 
                            descStr += "<spring:message code="ti.keywords"/>: "+processingKeyword+"\n";
                            descStr += "<spring:message code="listVulnerabilities.creationDate"/>: "+createDate+"\n";   
                            $("#ticketName").val('<spring:message code="dataLeakage.title"/>: ' + decodeHtml(alertName));
                            $("#ticketDescription").val(descStr);
                            $("#createTicketModal").modal();
                        } );
                    });
                    function listKeywords(parsedContent, row) {
                        var html = '';
                        var dataLeakageRowResult = parsedContent.dataLeakageUrlResult;
                        if (dataLeakageRowResult.length > 0) {
                            dataLeakageRowResult.forEach(function (entry, index, arr) {
                                if (index >= 10) {
                                    html += '<li id=' + entry.contentId + ' class=' + entry.keyword.trim().replace(/ /g, '') + ' title=' + entry.keyword + ' style="display: none;list-style-type : none;">';
                                } else {
                                    html += '<li id=' + entry.contentId + ' class=' + entry.keyword.trim().replace(/ /g, '') + ' title=' + entry.keyword + ' style="list-style-type : none;">';
                                }
                                if (entry.keyword.length > 120) {
                                    html += '<a style="color: #333333;" data-toggle="popover" data-content="' + entry.keyword + '" onClick=urlDetailsSingle(\'' + entry.contentId + '\',\'' + entry.keyword.trim().replace(/ /g, '') + '\') >' + entry.keyword.substring(0, 120) + "..." + '</a>';
                                } else {
                                    html += '<a style="color: #333333;" onClick=urlDetailsSingle(\'' + entry.contentId + '\',\'' + entry.keyword.trim().replace(/ /g, '') + '\') >' + entry.keyword + '</a>';
                                }
                                html += '</li>';
                                if (index < 10 && index != dataLeakageRowResult.length - 1) {
                                    html += '<hr style="margin-bottom:0px;margin-top:0px;margin-right:-10px;border: none; border-bottom: 1px solid #e7ecf1;">';
                                }
                            });
                            if (dataLeakageRowResult.length > 10) {
                                html += '<input type="button" style="margin-top: 10px" class="btn" value="<spring:message code="generic.more"/>" onclick="loadMore(' + row + ', this)"></input>';
                            }
                            return html;
                        } else {
                            return "<i class=\"fas fa-minus\"></i>";
                        }
                    }
                    var lists;
                    function loadMore(rowIndex, button) {
                        $('#detailList').modal('show');
                        var selectedRow = oTable.row(rowIndex).node();
                        lists = selectedRow.getElementsByTagName("li");
                        for (var i = 0; i < lists.length / 2; i++) {
                            var li = document.createElement("li");
                            li.style.listStyleType = "none";
                            var hr = document.createElement("hr");
                            hr.style.marginBottom = "0px";
                            hr.style.marginTop = "0px";
                            hr.style.marginRight = "-15px";
                            hr.style.border = "none";
                            hr.style.borderBottom = "1px solid #e7ecf1";
                            var link = document.createElement("a");
                            link.style.color = "black";
                            link.onclick = function (lists) {
                                return function () {
                                    urlDetails(lists);
                                };
                            }(lists[i]);
                            li.appendChild(link);
                            var text = document.createTextNode(lists[i].textContent);
                            link.appendChild(text);
                            $('#linkMore').append(li);
                            $('#linkMore').append(hr);
                        }
                    }

                    $('#detailList').on("hidden.bs.modal", function () {
                        $('#linkMore').empty();
                        $('#keywordsMore').empty();
                    });

                    function urlDetails(param) {
                        $("#urlDetails").modal('show');
                        $("#modalHeader").html('<spring:message code="ti.urlContent"/>');
                        $.post("getUrlContent.json", {
                            'id': param.id,
                    ${_csrf.parameterName}: "${_csrf.token}"
                        }).always(function (data, textStatus, jqXHR) {
                            $("#modalBody").html(highlightKeywords(htmlEscape(data.body), param.className));
                        });

                    }

                    function urlDetailsSingle(id, keyword) {
                        $("#urlDetails").modal('show');
                        $("#modalHeader").html('<spring:message code="ti.urlContent"/>');
                        $.post("getUrlContent.json", {
                            'id': id,
                    ${_csrf.parameterName}: "${_csrf.token}"
                        }).always(function (data, textStatus, jqXHR) {
                            $("#modalBody").html(highlightKeywords(htmlEscape(data.body), keyword));
                        });
                    }
                    function htmlEscape(str) {
                        return str
                                .replace(/&/g, '&amp;')
                                .replace(/"/g, '&quot;')
                                .replace(/'/g, '&#39;')
                                .replace(/</g, '&lt;')
                                .replace(/>/g, '&gt;');
                    }
                    function highlightKeywords(html, keywords) {
                        var keywordList = keywords.split(',');
                        for (var i = 0; i < keywordList.length; i++) {
                            var keyword = keywordList[i].trim();
                            if (keyword != null && keyword != "") {
                                var regEx = new RegExp(keyword, "ig");
                                html = html.replace(regEx, '<mark style=" background-color: yellow;color: black;">' + keyword + '</mark>');
                            }
                        }
                        return html;
                    }

                    function deleteAlert() {
                        var alertIds = [];
                        $('input[id=checkDataLeakageAlerts]:checked').each(function () {
                            alertIds.push($(this).val());
                        });
                        $.post("deleteTiData.json", {
                            'type': 'dataLeakage',
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
                    <jsp:include page="/WEB-INF/jsp/ti/include/ticketModal.jsp" />
            </jsp:attribute>
            <jsp:attribute name="button">
                <div class="portlet-body" style="margin-top:-1.5%">
                    <p>
                        <a class="btn btn-primary btn-info btn-sm" onclick="deleteAlert()" ><spring:message code="generic.delete"/></a>
                    </p> 
                </div>
            </jsp:attribute>
            <jsp:body>
                <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                    <thead class="datatablesThead">
                        <tr>
                            <th style="vertical-align: middle;width:2%"><input type="checkbox" class="editor-active" id="selectAll" onclick="selectAll('checkDataLeakageAlerts');"></th>
                            <th style="vertical-align: middle;width:40%"><spring:message code="ti.alertName"/></th>
                            <th style="vertical-align: middle;width:40%"><spring:message code="ti.keywords"/></th>
                            <th style="vertical-align: middle;width:10%"><spring:message code="listVulnerabilities.creationDate"/></th> 
                            <th style="vertical-align: middle;width:8%" class="sorting_disabled" rowspan="1" colspan="1" aria-label=" "> </th>
                        </tr>
                    </thead>                                
                </table>
                <div class="modal fade bs-modal-lg in" id="urlDetails" tabindex="-1" aria-hidden="true" style="margin-top: 50px;display: none;z-index: 11100"> 
                    <div class="modal-dialog modal-lg" style="z-index: 11110">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 id="modalHeader" class="modal-title"></h4>
                                <div id="modalHeader" ></div> 
                            </div>
                            <div class="modal-body" style="height: 500px;overflow-y: scroll;">
                                <div  id="modalBody" rows="30" style="width:100%;border: none;white-space: pre-wrap;">

                                </div>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" id="contentId" />
                </div>
                <div class="modal fade" id="detailList" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="z-index: 10050">
                    <div class="modal-dialog" style="z-index: 10049" >
                        <div class="modal-content" style="width:1200px;margin-left: -300px">
                            <div class="modal-header">
                                <h4 class="modal-title"><spring:message code="generic.details"/></h4>
                            </div>
                            <div class="modal-body" style="height: 500px;overflow-y: scroll;">
                                <div class="col-md-9">
                                    <div id="linkMore" style="width: 50% " >
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div id="keywordsMore" >
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
                    .dataTables_wrapper{
                        margin-top: -48px;
                    }
                </style>
            </jsp:body>
        </biznet:mainPanel>
    </body>
</html>
