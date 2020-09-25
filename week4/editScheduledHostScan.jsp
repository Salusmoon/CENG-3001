<%-- 
    Document   : editScheduledHostScan
    Created on : 22-Dec-2017, 10:21:46
    Author     : adem.dilbaz
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>                          
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="generic.bizzy"/></title>
    </head>
    <body>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#scanAssets").select2({
                    tags: true
                });
                $('#dateTimeScan').datetimepicker({
                });
                getPentestScanners("hostScan");
                if ('<c:out value = "${scan.resultAction}"/>' === '2' || '<c:out value = "${scan.resultAction}"/>' === '4') {
                    $('#minRiskLevel').show();
                    $('#assetGroup').show();
                    getPentestScanners("scan");
                } else if ('<c:out value = "${scan.resultAction}"/>' === '1') {
                    $('#minRiskLevel').hide();
                    $('#assetGroup').show();
                } else if ('<c:out value = "${scan.resultAction}"/>' === '3') {
                    $('#minRiskLevel').hide();
                    $('#assetGroup').hide();
                } else if ('<c:out value = "${scan.resultAction}"/>' === '5') {
                    $('#minRiskLevel').hide();
                    $('#assetGroup').hide();
                }
                $('#scanEngine').on('change', function () {
                    getPentestScanners("hostScan");
                });
                $('#scanEngineForScan').on('change', function () {
                    getPentestScanners("scan");
                });

                $('#occurrence').on('change', function () {
                    if ($('#occurrence').val() === "ON_DEMAND") {
                        $('#recurrence').val(1);
                        $('#recurrence').attr("disabled", "disabled");
                    } else {
                        $('#recurrence').val("");
                        $('#recurrence').removeAttr("disabled");
                    }
                });

                $('#resultAction').on('change', function () {
                    $('#alarmLevel').hide();
                    $('#minRiskLevel').hide();
                    $('#assetGroup').hide();
                    $('#scannerDivForScan').hide();
                    $('#serverDivForScan').hide();
                    $('#policyDivForScan').hide();
                    $('#timezoneDivForScan').hide();

                    if ($('#resultAction').val() === '1') {
                        $('#assetGroup').show();
                    } else if ($('#resultAction').val() === '2' || $('#resultAction').val() === '4') {
                        $('#minRiskLevel').show();
                        $('#assetGroup').show();
                        getPentestScanners("scan");
                        $('#scannerDivForScan').show();
                        $('#serverDivForScan').show();
                        $('#policyDivForScan').show();
                        $('#timezoneDivForScan').show();
                    } else if ($('#resultAction').val() === '5') {
                        $('#alarmLevel').show();    //Alarm üret
                    }
                });
            });

            function getPentestScanners(param) {
                $('#startScanModal').modal('show');
                $("#startScanModal").block({message: null});
                App.startPageLoading({animate: true});
                if (param === "hostScan") {
                    $.get("getScanners.json", {serverId: $('#scanEngine').val(), ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {
                        if (data !== null && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                $('#pentestScanner').append('<option value=' + data[i].id + '>' + data[i].name + '</option>');
                            }
                            $('#scannerDiv').show();
                        } else {
                            $('#scannerDiv').hide();
                        }
                        getPentestPolicies(param);
                        getPentestTimezones(param);
                        $('#pentestScanner').val('<c:out value = "${scan.scanner.id}"/>');
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.connectionFail"/>");
                        $("#alertModal").modal("show");
                    });
                } else {
                    $('#serverDivForScan').show();
                    $.get("getScanners.json", {serverId: $('#scanEngineForScan').val(), ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {
                        if (data !== null && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                $('#pentestScannerForScan').append('<option value=' + data[i].id + '>' + data[i].name + '</option>');
                            }
                            $('#scannerDivForScan').show();
                        } else {
                            $('#scannerDivForScan').hide();
                        }
                        getPentestPolicies(param);
                        getPentestTimezones(param);
                        $('#pentestScannerForScan').val('<c:out value = "${scan.scannerIdForScan}"/>');
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.connectionFail"/>");
                        $("#alertModal").modal("show");
                    });
                }
            }
            function getPentestPolicies(param) {
                if (param === "hostScan") {
                    $.get("getPolicies.json", {serverId: $('#scanEngine').val(), ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {

                        if (data !== null && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                $('#pentestPolicy').append('<option value=' + data[i].id + '>' + data[i].name + '</option>');
                                $('#policyDiv').show();
                                $('#paramsDiv').hide();
                                $('#portsDiv').hide();
                            }
                        } else {
                            $('#policyDiv').hide();
                            $('#paramsDiv').show();
                            $('#portsDiv').show();
                        }
                        $('#pentestPolicy').val('<c:out value = "${scan.policyId}"/>');
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.connectionFail"/>");
                        $("#alertModal").modal("show");
                    });
                } else {
                    $.get("getPolicies.json", {serverId: $('#scanEngineForScan').val(), ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {

                        if (data !== null && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                $('#pentestPolicyForScan').append('<option value=' + data[i].id + '>' + data[i].name + '</option>');
                                $('#policyDivForScan').show();
                            }
                        } else {
                            $('#policyDivForScan').hide();
                        }
                        $('#pentestPolicyForScan').val('<c:out value = "${scan.policyIdForScan}"/>');
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.connectionFail"/>");
                        $("#alertModal").modal("show");
                    });
                }
            }
            function getPentestTimezones(param) {
                if (param === "hostScan") {
                    $.get("getTimezones.json", {serverId: $('#scanEngine').val(), ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {

                        if (data !== null && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                $('#pentestTimezone').append('<option value=' + data[i].value + '>' + data[i].name + '</option>');
                                $('#timezoneDiv').show();
                                $("#pentestTimezone").val("Turkey"); //Select Box refresh edilmesini sağlar.
                            }
                        } else {
                            $('#timezoneDiv').hide();
                        }
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.connectionFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        $("#pentestTimezone").val('<c:out value = "${scan.timezone.value}"/>');
                        $("#startScanModal").unblock({message: null});
                        App.stopPageLoading();
                        $('#startScanModal').modal('hide');
                    });
                } else {
                    $.get("getTimezones.json", {serverId: $('#scanEngineForScan').val(), ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {

                        if (data !== null && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                $('#pentestTimezoneForScan').append('<option value=' + data[i].value + '>' + data[i].name + '</option>');
                                $('#timezoneDivForScan').show();
                                $("#pentestTimezoneForScan").val("Turkey"); //Select Box refresh edilmesini sağlar.
                            }
                        } else {
                            $('#timezoneDivForScan').hide();
                        }
                    }).fail(function () {
                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="generic.connectionFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                        $("#pentestTimezoneForScan").val('<c:out value = "${scan.timezoneForScan}"/>');
                        $("#startScanModal").unblock({message: null});
                        App.stopPageLoading();
                        $('#startScanModal').modal('hide');
                    });
                }
            }
        </script>
<jsp:include page="../tool/jsInformationOkCancelModal.jsp" />

        <div class="row">
            <div class="col-lg-12">
                <h3 class="page-title"><spring:message code="editAssetDiscovery.scheduled"/></h3>
            </div>
        </div>
        <!-- /.col-lg-12 -->
        <div class="row">
            <div class="col-lg-12">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"> 
                                <spring:message code="generic.edit"/>
                            </span>
                        </div>
                    </div>
                    <div class="portlet-body">                       
                        <form:form commandName="scheduledAssetDiscovery" role="form" action="editScheduledHostScan.htm" method="POST" autocomplete="off">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="form-group required">
                                        <label><spring:message code="startScan.name"/></label>
                                        <form:input class="form-control" path="name" placeholder=""/>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="startScan.description"/></label>
                                        <form:textarea class="form-control" path="description" rows="3" />
                                    </div>
                                    <div class="form-group required">
                                        <label><spring:message code="startScan.target"/></label>
                                        <form:select class="js-example-tags form-control" style="width: 100%;" id="scanAssets" items="${targetList}" multiple="multiple" path="target">
                                            <option selected></option>
                                        </form:select>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="startQualysScan.excludeIps"/></label>
                                        <form:input class="js-example-tags form-control" id="excludeAssets" multiple="multiple" path="excludeIps" placeholder="" />
                                    </div>
                                    <div class="form-group required">                                        
                                        <label><spring:message code="startScan.scanEngine"/></label>
                                        <form:select class="form-control" id="scanEngine" path="server.settingId" >
                                            <form:option value="-1" ><spring:message code="startScan.selectEngine" /></form:option>
                                            <form:options items="${hostScanEngines}" itemValue="settingId" itemLabel="name" />                                           
                                        </form:select>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="scannerDiv">                                        
                                        <label><spring:message code="startScan.scanner"/></label>
                                        <form:select id="pentestScanner" class="form-control" path="scanner.id">                                         
                                        </form:select>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="policyDiv">                                        
                                        <label><spring:message code="startScan.policy"/></label>
                                        <form:select id="pentestPolicy" class="form-control" path="policyId">                                         
                                        </form:select>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="timezoneDiv">                                        
                                        <label><spring:message code="startScan.timezone"/></label>
                                        <form:select id="pentestTimezone" class="form-control" path="timezone.value">                                         
                                        </form:select>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="portsDiv">
                                        <label><spring:message code="startScan.ports"/></label>
                                        <form:input class="form-control" path="ports" placeholder=""/>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="paramsDiv">
                                        <label><spring:message code="startScan.params"/></label>
                                        <form:input class="form-control" path="params" placeholder=""/>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><spring:message code="startScan.startDate"/></label>
                                        <div class='input-group date' id='dateTimeScan'>
                                            <form:input path="scanDate" class="form-control" id="dateInput"  />
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="startQualysScan.occurence"/></label>
                                        <form:select class="form-control" path="launch" id="occurrence">
                                            <form:options items="${scanLaunchForScheduled}" />
                                        </form:select>
                                        <form:errors path="launch" cssClass="text-danger" element="p"/>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="startQualysScan.recurrence"/></label>
                                        <p style="margin-top: 0px; margin-bottom: 0px;"><spring:message code="listScans.scanLimitWarning"/></p>            
                                        <form:input class="form-control" path="recurrence" placeholder="" id="recurrence" onkeypress='return event.charCode >= 48 && event.charCode <= 57'/>
                                        <form:errors path="recurrence" cssClass="text-danger" element="p"/>
                                    </div>
                                    <div class="form-group" id="timeIntervalDiv">                                        
                                        <label><spring:message code="startScan.scanProscriptiveTime"/></label>
                                        <p style="margin-top: 0px; margin-bottom: 0px;"><spring:message code="startScan.scanProscriptiveHint"/></p>
                                        <div class="col-lg-6 " style="padding-left: 0px;">
                                            <div class='input-group clockpicker' id='scanProscriptiveTimeStart'>
                                                <form:input type='text' class="form-control" path="scanProscriptiveTimeStart"/>
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-time"></span>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 " style="padding-right: 0px;">
                                            <div class='input-group clockpicker' id='scanProscriptiveTimeEnd'>
                                                <form:input type='text' class="form-control" path="scanProscriptiveTimeEnd" />
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-time"></span>
                                                </span>
                                            </div>
                                        </div>
                                    </div>        
                                    <div class="form-group">                                        
                                        <label><spring:message code="startAssetDiscovery.postAction"/></label>  
                                        <form:select class="form-control" id="resultAction" path="resultAction">
                                            <form:option value="1"><spring:message code="startAssetDiscovery.saveAssets"/></form:option>
                                            <form:option value="5"><spring:message code="startAssetDiscovery.createAlarm"/></form:option>
                                            <form:option value="2"><spring:message code="startAssetDiscovery.scanAllAssets"/></form:option>
                                            <form:option value="4"><spring:message code="startAssetDiscovery.scanNewAssets"/></form:option>
                                            <form:option value="3"><spring:message code="startAssetDiscovery.doNotTakeAction"/></form:option>
                                        </form:select>
                                    </div>
                                    <div class="form-group" id="assetGroup">                                        
                                        <label><spring:message code="startAssetDiscovery.assetGroupToBeSaved"/></label>
                                        <form:select class="form-control" path="assetGroupId">
                                            <form:option value="-1"><spring:message code="startAssetDiscovery.selectAssetGroup"/></form:option>
                                            <form:options items="${assetGroups}" itemValue="groupId" itemLabel="name"/>                                           
                                        </form:select>
                                    </div>
                                    <div class="form-group required" id="alarmLevel">                                        
                                        <label><spring:message code="startAssetDiscovery.alarmLevel"/></label>
                                        <p style="margin-top: 0px; margin-bottom: 0px;"><spring:message code="startAssetDiscovery.alarmHint"/></p>
                                        <form:select class="form-control" path="alarmLevel">
                                            <form:option value="1">1</form:option>
                                            <form:option value="2">2</form:option>
                                            <form:option value="3">3</form:option>
                                            <form:option value="4">4</form:option>
                                            <form:option value="5">5</form:option>                                  
                                        </form:select>
                                    </div>
                                    <div class="form-group">
                                        <label><spring:message code="startAssetDiscovery.mail"/></label>
                                        <form:input class="form-control valMail" path="mail" placeholder=""/>
                                        <form:errors path="mail" cssClass="text-danger" element="p"/>
                                    </div>
                                    <div class="form-group required" id="minRiskLevel"> 
                                        <label><spring:message code="startScan.minRiskLevel"/></label>
                                        <form:select class="form-control" path="minRiskLevel" >
                                            <form:option value="0">0</form:option>
                                            <form:option value="1">1</form:option>
                                            <form:option value="2">2</form:option>
                                            <form:option value="3">3</form:option>
                                            <form:option value="4">4</form:option>
                                            <form:option value="5">5</form:option>                                         
                                        </form:select>
                                    </div>
                                    <div class="form-group">
                                        <form:checkbox class="editor-active" path="active" placeholder=""/>
                                        <label><spring:message code="listScans.active"/></label>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="serverDivForScan">                                        
                                        <label><spring:message code="startScan.scanEngine"/></label>
                                        <form:select class="form-control" id="scanEngineForScan" path="serverIdForScan">
                                            <form:option value="-1"><spring:message code="startScan.selectEngine"/></form:option>
                                            <form:options items="${scanEngines}" itemValue="settingId" itemLabel="name"/>                                           
                                        </form:select>
                                    </div>  
                                    <div class="form-group required" style="display:none;" id="scannerDivForScan">                                        
                                        <label><spring:message code="startScan.scanner"/></label>
                                        <form:select id="pentestScannerForScan" class="form-control" path="scannerIdForScan">                                         
                                        </form:select>
                                    </div>
                                    <div class="form-group required" style="display:none" id="policyDivForScan">                                        
                                        <label><spring:message code="startScan.policy"/></label>
                                        <form:select id="pentestPolicyForScan" class="form-control" path="policyIdForScan">                                         
                                        </form:select>
                                    </div>
                                    <div class="form-group required" style="display:none;" id="timezoneDivForScan">                                        
                                        <label><spring:message code="startScan.timezone"/></label>
                                        <form:select id="pentestTimezoneForScan" class="form-control" path="timezoneForScan">                                         
                                        </form:select>
                                    </div>
                                    <form:input type="hidden" path="id" name="id" id="id"/>
                                    <form:input type="hidden" path="source"/>
                                    <input type="hidden" id="message" value="${message}"/>
                                    <br><br>
                                    <div style="float:right">
                                        <button type="submit" class="btn btn-success btn-lg" ><spring:message code="addVulnerability.submit"/></button>
                                        <button type="reset" class="btn btn-danger btn-lg" onclick="if (window.history.back()) {
                                                    window.history.back();
                                                } else {
                                                    window.close();
                                                }"><spring:message code="addVulnerability.reset"/></button>
                                    </div>
                                </div>
                            </div>
                        </form:form>

                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
            <div class="modal fade" id="startScanModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

            </div>
            <!-- /.col-lg-12 -->
        </div>
    </body>
</html>
