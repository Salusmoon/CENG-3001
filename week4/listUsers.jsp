<%-- 
    Document   : listUsers
    Created on : 01.Ara.2017, 10:22:25
    Author     : mustafa.ergan
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>

<biznet:mainPanel viewParams="title,search,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listUsers.title"/></span>
            </li>
        </ul>
    </jsp:attribute>
    <jsp:attribute name="search">
        <sec:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PENTEST_ADMIN')">

            <biznet:searchpanel tableType="genericDatatable" tableName="loadDatatable">
                <jsp:body>
                    <div class="row" style="margin-bottom: 1em;margin-left: 1px;">
                        <label class="col-lg-1 control-label" id="labelcustomer" style="font-size: 12px;padding-top: 8px;"><b><spring:message code="listVulnerabilities.customer"/></b></label>
                        <div class="col-lg-2" id="SearchPanel" >
                            <select id="customers" name="customers" class=" js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                <c:forEach items="${customers}" var="customer">
                                    <option value="<c:out value="${customer.customerId}"/>" ><c:out value="${customer.companyName}" /></option>
                                </c:forEach>
                            </select> 
                        </div>
                        <label class="col-lg-1 control-label" id="labelcustomer" style="font-size: 12px; padding-top: 8px;"><b><spring:message code="login.username"/></b></label>
                        <div class="col-lg-2">
                            <input class="form-control" id="searchUsers" name="searchUsers"  placeholder="">
                        </div>
                    </div>
                    <input type="hidden" id="customerURLId" value="<c:out value="${customerURLId}" />"/>
                </jsp:body>
            </biznet:searchpanel> 
        </sec:authorize>

        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER')">         
            <biznet:searchpanel tableType="genericDatatable" tableName="loadDatatable">
                <jsp:body>
                    <div class="row" style="margin-bottom: 1em;margin-left: 1px;">
                        <label class="col-lg-1 control-label control-label" id="labelcustomer" style="font-size: 12px;padding-top: 8px;"><b><spring:message code="login.username"/></b></label>
                        <div class="col-lg-2">
                            <input class="form-control" id="searchUsers" name="searchUsers"  placeholder="">
                        </div>
                    </div>
                </jsp:body>
            </biznet:searchpanel>


        </sec:authorize>
    </jsp:attribute> 

    <jsp:attribute name="button">
        <div class="portlet-body">
        <a class="btn btn-primary btn-sm" href="addUser.htm?customerId=<c:out value="${customerId}" />&customerURLId=<c:out value="${customerURLId}" />">
                <spring:message code="listUsers.addUser"/></a>
        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
        <div class="btn-group">
            <a class="btn btn-sm btn-default btn-success dropdown-toggle" data-toggle="dropdown" href="javascript:;" aria-expanded="false"> 
                <spring:message code="listVulnerabilities.actions"/>
                <i class="fas fa-angle-down"></i>
            </a>
            <ul class="dropdown-menu">    
                    <li>
                        <a onclick="showAssignModal()"><spring:message code="listUsers.assignGroup"/></a>
                    </li>
            </ul>
        </div>
        </sec:authorize>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <spring:message code="${error}"></spring:message>
                </div>
        </c:if>
        </div>
    </jsp:attribute>

    <jsp:attribute name="script">

        <script type="text/javascript">
            document.title = "<spring:message code="genericdb.USER"/> - BIZZY";
            var url_string = window.location.href;
            var url = new URL(url_string);
            var filterCustomerId =url.searchParams.get("customerId");
            $('#customers').val(filterCustomerId).trigger("change");
            function actionDatatable(row, type, tableId) {
                if (type === "update") {
                    if (row.customer && row.customer.customerId)
                        window.location = "addUser.htm?action=update&userId=" + row.userId + "&customerURLId=" + row.customer.customerId;
                    else
                        window.location = "addUser.htm?action=update&userId=" + row.userId;
                } else if (type === "statusPassive") {
                    updateAccountStatus(row.userId, false);
                } else if (type === "statusActive") {
                    updateAccountStatus(row.userId, true);
                } else if (type === "resetPassword") {
                    resetPasswordDatatable(row.userId);
                } else if (type === "delete") {
                    function  confirmDelete() {
                        $.ajax({
                            "type": "POST",
                            "url": "deleteUser.json",
                            "data": {
                                '${_csrf.parameterName}': "${_csrf.token}",
                                'userId': row.userId
                            },
                            success: function (alert) {
                                if (alert === "") {
                                    loadDatatable();
                                } else {
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html(alert.errorText);
                                    $("#alertModal").modal("show");
                                }
                            },
                            error: function (jqXHR, textStatus, errorThrown) {
                                if(jqXHR.status === 403) {
                                    window.location = '../error/userForbidden.htm';
                                } else {
                                    ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                                }
                            }
                        });
                    }
                    ;
                    jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listUsers.confirmDelete"/>"), confirmDelete);
                }
            }

            function updateAccountStatus(id, status) {
                var r;
                if (status) {
                    r = confirm(decodeHtml("<spring:message code="listUsers.confirmActivateAccount"/>"));
                } else {
                    r = confirm(decodeHtml("<spring:message code="listUsers.confirmPassivateAccount"/>"));
                }

                if (r === true) {
                    $.post("updateAccountStatus.json", {userId: id, status: status, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        loadDatatable();
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listUsers.updateAccountSuccess"/>");
                        $("#alertModal").modal("show");
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        if(jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listUsers.updateAccountFailed"/>");
                            $("#alertModal").modal("show");
                        }
                    });
                }
            }
            function showAssignModal(){
                $('#userAssignModal').modal('show');
            }
            function assignGroups() {
                    var userIds = [];
                    $('#data input:checked').each(function () {
                        var tr = $(this).closest('tr');
                        var row = $("#displayTable").dataTable().DataTable().row(tr);
                        userIds.push(row.data().userId);
                    });
                    var groupIds = [];
                    groupIds = $("#groups").val();
                    if(userIds.length==0){
                        
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code='listuser.select'/>");
                        $("#buttonback").html("<spring:message code='generic.submit'/>");
                        $('#userAssignModal').modal('hide');
                        $("#alertModal").modal("show");
                       
                    }
                    else {
                    $.post("assignUsersToGroups.json", {
                        'userIds': userIds,
                        'groupIds': groupIds, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        location.reload();
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        if(jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listAssets.assignFail"/>");
                            $("#alertModal").modal("show");
                        }
                    }).always(function () {
                    });
                    }
            }
            function resetPasswordDatatable(id) {

                function confirmResetDatatable() {
                    $.post("sendResetPasswordMail.json", {userId: id, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (result) {
                        if (result.error === "canNotResetLdapUser") {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listUsers.cannotReset"/>");
                            $("#alertModal").modal("show");
                        } else {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listUsers.success"/>");
                            $("#alertModal").modal("show");
                        }

                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        if(jqXHR.status === 403) {
                            window.location = '../error/userForbidden.htm';
                        } else {
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listUsers.resetFail"/>");
                            $("#alertModal").modal("show");
                        }
                    }).always(function () {
                    });
                }
                jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listUsers.confirmReset"/>"), confirmResetDatatable);
            }
            var placeholder = decodeHtml("<spring:message code="listUsers.selectUserGroup"/>");
            $(".js-example-placeholder-multiple").select2({
                placeholder: placeholder
            });

        </script>

        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />

    </jsp:attribute>                        

    <jsp:body>

        <biznet:genericdatatable datatableURL="loadUsers.json" datatableActions="checboxSelectId,update,resetPassword,delete,status" searchFormId="searchForm" urlParams="var val=$('#customerURLId').val();'customerId='+val;var customerId=$('#customers').val();'customerId='+customerId+'&customerId='+val;"></biznet:genericdatatable>
            <div class="modal fade" id="userAssignModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog" style="width:25%">
                    <div class="modal-content">
                        <div class="modal-header">
                        <spring:message code="listuser.assigngroup"/>
                    </div>
                    <div class="modal-body">                       
                        <div class="panel-body">
                            <label><spring:message code="addUser.groups"/></label>
                            <select id="groups" class="js-example-placeholder-multiple js-states form-control" multiple="multiple" style="width:70%;">
                                <c:forEach items="${groups}" var="group">
                                    <option value="<c:out value="${group.id}"/>"><c:out value="${group.name}"/></option>
                                </c:forEach>
                            </select>
                            <p></p>
                            <p></p>
                            <div class="modal-footer">
                                <div class="row">
                                    <button type="buttonback" id="doNotConfirmGroup" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                    <button onClick="assignGroups()"  class="btn btn-success success"><spring:message code="listAssets.assignGroup"/></button>
                                </div>
                            </div>
                        </div>
                    </div>       
                </div>  
            </div>
        </div>
    </jsp:body>

</biznet:mainPanel>