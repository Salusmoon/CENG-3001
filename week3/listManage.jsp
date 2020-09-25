<%-- 
    Document   : setGraphic
    Created on : 08/2017
    Author     : mustafa.ergan
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="context" value="${pageContext.request.contextPath}" />
<biznet:mainPanel viewParams="title,body">
    <jsp:attribute name="title">    <%-- title = "Ana sayfa" --%>
        <link href="${context}/resources/css/priorityName.css" rel="stylesheet" type="text/css" /> 
        <link href="${context}/resources/assets/global/plugins/bootstrap-fileinput/bootstrap-fileinput.min.css" rel="stylesheet" type="text/css" />
        <link href="${context}/resources/assets/global/plugins/jstree/dist/themes/default/style.min.css" rel="stylesheet" type="text/css" />
        <ul class="page-breadcrumb breadcrumb">
            <li>
                <a class="title" href="../../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="ticket.manage.title"/></span>
            </li>
        </ul>

    </jsp:attribute>
    
    <jsp:attribute name="script">
        
          <style>

           #serverDatabase_processing
           {
            margin-top: -5%;      
            z-index: 1200;              
           }
        </style>
        
    <script type="text/javascript">
        document.title = "<spring:message code="ticket.manage.title"/> - BIZZY";
        var oTable;
            $(document).ready(function () {
                oTable = $('#serverDatabase').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "scrollX": true,
                    "stateSave": true,
                    "language": {
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                        "processing": "<spring:message code="generic.tableLoading"/>",
                        "search": "<spring:message code="generic.search"/>",
                        "paginate": {
                            "next": "<spring:message code="generic.next"/>",
                            "previous": "<spring:message code="generic.back"/>"
                        },
                        "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                        "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                        "infoEmpty":  "<spring:message code="generic.tableInfo" arguments="${'0'},${'0'},${'0'}"/>"
                    },
                    "columns": [
                        {"data": function (data) {
                            switch (data.name) {
                                case '0' :
                                    return '<div class="priorityName0 priorityNameCommon"><b>' + data.name + '</b></div>';
                                case '1' :
                                    return '<div class="priorityName1 priorityNameCommon"><b>' + data.name + '</b></div>';
                                case '2' :
                                    return '<div class="priorityName2 priorityNameCommon"><b>' + data.name + '</b></div>';
                                case '3' :
                                    return '<div class="priorityName3 priorityNameCommon"><b>' + data.name + '</b></div>';
                                case '4' :
                                    return '<div class="priorityName4 priorityNameCommon"><b>' + data.name + '</b></div>';
                                case '5' :
                                    return '<div class="priorityName5 priorityNameCommon"><b>' + data.name + '</b></div>';
                            }
                               return '<div><b>invalid priority name!</b></div>';
                            },
                            "orderable": false,"searchable": false
                        },
                        {"data": "time", "orderable": true},
                        {"data": 'date_name',"orderable": false,"searchable": false},
                        {
                            "data": function (data) {
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                                html = '<a class="btn btn-success btn-sm" style="margin-left: 9px;" onclick="deleteRow(\'' + data.ticket_priority_time_id + '\',\'update\')" data-placement="top"><i class="fas fa-pen-square"></i></a>&nbsp;'; ;
                                html += '<a class="btn btn-danger btn-sm" style="margin-left: 9px;" onclick="deleteRow(\'' + data.ticket_priority_time_id + '\',\'delete\')" data-placement="top"><i class="fas fa-times"></i></a>';
            </sec:authorize>;
                
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "listManage.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
                            d.customerId = "${custom:escapeForJavascript(customerId)}";
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listAssetGroups.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    },
                    "initComplete": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $("[data-toggle=popover]").popover();
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
                        }).attr("placeholder", decodeHtml("<spring:message code="listAssetGroups.searchTip" htmlEscape="false"/>")).width('220px');
            });

        function deleteRow(ticketID, type) {
                if(type==="update"){
                window.location = "addPriorityTime.htm?action=update&ticketPriorityTimeId="+ticketID;
                }else if(type==="delete"){
                    $.ajax({
                       "type": "POST",
                       "url": "deletePriorityTime.form",
                       "data": {
                                'ticketPriorityTimeId': ticketID,
                                ${_csrf.parameterName}: "${_csrf.token}"
                        },
                        success : function (taskValue) {
                            oTable.api().ajax.reload()
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                                ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                        }
                    });
            }
        }
        
    </script>
        
    </jsp:attribute>
    
    <jsp:attribute name="button"> <%-- "Yeni" butonu --%>
        <a class="btn btn-primary btn-sm" href="addPriorityTime.htm"><spring:message code="listTickets.addTicket"/></a>
    </jsp:attribute>

        
    <jsp:body>
        
        <div class="portlet-body">
            <div>

                <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatabase" style="width: 100%;">
                    <thead class="datatablesThead">
                        <tr>
                            <th style="vertical-align: middle;" width="200px"><spring:message code="listManage.priority"/></th>
                            <th style="min-width: 230px;" width="150px"><spring:message code="listManage.time"/></th>
                            <th style="min-width: 100px;" width="100px"><spring:message code="listManage.timeType"/></th>
                            <th style="min-width: 100px;" width="100px"> </th>
                        </tr>
                    </thead>
                </table>

            </div>
            <a class="btn btn-primary btn-sm" onclick="window.history.back()"><spring:message code="generic.back"/></a>                          
        </div>
        
    </jsp:body>

</biznet:mainPanel>