<%-- 
    Document   : assetsAssignToGroup
    Created on : 12 Kas 2019, 17:05:15
    Author     : mami
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<biznet:mainPanel viewParams ="title,body">
    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> 
            <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="assetGroupMatching.title"/></span>
            </li>
        </ul>
    </jsp:attribute>
    <jsp:attribute name="script">
          <style>
         
            
           #assetTable_processing
           {
            margin-top:  -16%;      
            z-index: 1200;              
           }
           
           #assetGroupTable_processing
           {
            margin-top: -22%;      
            z-index: 1200;              
           }
        </style>
        <script type="text/javascript">
            document.title = "<spring:message code="assetGroupMatching.title"/> - BIZZY";
            var dragSrcRow = null;
            var inGroup=[];
            var notInGroup=[];
            var selectedRows = [];
            var srcTable = '';
            var rows = [];
            var rows2 = [];
            var labelsAndColors = [];
            var labelsList = []; 
            var assetColors = [];
            <c:forEach var="item" items="${assetGroup}">
            assetColors.push("default");
            assetColors.push("info");
            assetColors.push("success");
            assetColors.push("warning");
            assetColors.push("primary");
            assetColors.push("danger");
            </c:forEach>
            <c:forEach var="item" items="${assetGroup}" varStatus="loop">
            labelsAndColors.push('<span class="label label-' + assetColors.pop() + '">' + '<c:out value="${item.name}"/>' + '</span>' + '&nbsp');
            labelsList.push('<c:out value="${item.name}"/>');
            </c:forEach>
            $(document).ready(function () {
                $('#assetTable').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "bFilter": true,
                    "scrollX": true,
                    "language": {
                        "processing": "<spring:message code="generic.tableLoading"/>",
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                        "search": "<spring:message code="generic.search"/>  ",
                        "paginate": {
                            "next": "<spring:message code="generic.next"/>",
                            "previous": "<spring:message code="generic.back"/>"
                        },
                        "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                        "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                        "infoEmpty":  "<spring:message code="generic.tableInfo" arguments="${'0'},${'0'},${'0'}"/>"
                    },
                    createdRow: function (row, data, dataIndex, cells) {
                        $(row).attr('draggable', 'true');
                    },
                    "columns": [
                        {"data": 'assetId',
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkAsset" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                       {"data": 'ip',
                            render: function (data, type, row) {
                               if(row['hostname']==null || row['hostname']=='')
                                   return data;
                               else
                                   return data+" ("+row['hostname']+")";
                            },
                        },
                        {"data": function (data, type, dataToSet) {
                    var html = "";
                    var sendGroup = [];
                    var sendGroupResult = [];
                    var groupTree = "";
                    var groups = data.groups;
                    var groupsLength = data.groups.length;
                    var groupsLengthCount = 0;
                    for (var i = 0; i < groupsLength; i++) {
                    sendGroup = [];
                    groupTree = "";
                    if (groups[i].groupId !== "deleted"){
                    sendGroup.push(decodeHtml(groups[i].name));
                    for (var j = 0; j < labelsList.length; j++) {
                    if (decodeHtml(groups[i].name) === decodeHtml(labelsList[j])) {
                    groupsLengthCount++;
                    if (groups[i].parentGroupId !== null){
                    sendGroupResult = [];
                    var count = sendGroup.length - 1;
                    for (var l = 0; l < sendGroup.length; l++){
                    sendGroupResult[l] = sendGroup[count];
                    count--;
                    }
                    var k = 0;
                    for (; k < sendGroupResult.length - 1; k++){
                    groupTree += sendGroupResult[k] + " ➤ ";
                    }
                    groupTree += sendGroupResult[k];
                    labelsAndColors[j] = labelsAndColors[j].replace('<spring:message code="listAssets.groupTree"/>', groupTree);
                    }
                    if (groupsLengthCount % 3 == 0)
                            html += labelsAndColors[j] + '<br><br>';
                    else
                            html += labelsAndColors[j];
                    break;
                    }
                    }
                    }
                    }
                    groupsLengthCount = 0;
                    return '<div style="line-height:0.8;">' + html + '</div>';
                    },
                            "searchable": false,
                            "orderable": false
                    }
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadSmallDataAssets.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
                            d.customerId = "${customerId}";
                        }
                    },
                    "error": function (jqXHR, textStatus, errorThrown) {
                        ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                    },
                   
                    drawCallback: function () {

                        rows = document.querySelectorAll('#assetTable tbody tr');
                        [].forEach.call(rows, function (row) {
                            row.addEventListener('dragstart', handleDragStart, false);
                            row.addEventListener('dragover', handleDragOver, false);
                            row.addEventListener('drop', handleDrop, false);
                            row.addEventListener('dragend', handleDragEnd, false);

                        });
                    }
                });
                $('#assetGroupTable').dataTable({
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "bFilter": true,
                    "scrollX": true,
                    "language": {
                        "processing": "<spring:message code="generic.tableLoading"/>",
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                        "search": "<spring:message code="generic.search"/>  ",
                        "paginate": {
                            "next": "<spring:message code="generic.next"/>",
                            "previous": "<spring:message code="generic.back"/>"
                        },
                        "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                        "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                        "infoEmpty":  "<spring:message code="generic.tableInfo" arguments="${'0'},${'0'},${'0'}"/>"
                    },
                    "columns": [
                        {"data": 'assetId',
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    return '<input type="checkbox" class="editor-active" id="checkAssetsInGroup" value="' + data + '" >';
                                }
                                return data;
                            },
                            className: "dt-body-center",
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'ip',
                            render: function (data, type, row) {
                               if(row['hostname']==null || row['hostname']=='')
                                   return data;
                               else
                                   return data+" ("+row['hostname']+")";
                            },
                        },
                        {"data":function (data, type, row){
                                var html='<a onClick="deleteAssetGroupRelation(\''+data.assetId+'\')"  type="button" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="assetGroupMatching.deallocateAsset"/>"><i class="fas fa-times"></i></button> ';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadSmallDataAssetsByGroupId.json",
                        "data": function (d) {
                            d.${_csrf.parameterName} = "${_csrf.token}";
                            d.customerId = "${customerId}";
                            d.groupId = $('#assetGroup').val();
                        }
                    },
                    "error": function (jqXHR, textStatus, errorThrown) {
                        ajaxErrorHandler(jqXHR, textStatus, errorThrown, "<spring:message code="generic.tableError"/>");
                    },
                    drawCallback: function () {
                        // Add HTML5 draggable event listeners to each row
                        rows2 = document.querySelectorAll('#assetGroupTable tbody tr');
                        [].forEach.call(rows2, function (row) {
                            row.addEventListener('dragstart', handleDragStart, false);
                            row.addEventListener('dragover', handleDragOver, false);
                            row.addEventListener('drop', handleDrop, false);
                            row.addEventListener('dragend', handleDragEnd, false);

                        });
                    }
                });

            });
            $('#assetGroup').on('change', function () {
                $('#assetGroupTable').dataTable().api().draw();
                $("#selectAllAssetInGroup").prop("checked", false);
            });
            $('[data-toggle="tooltip"]').on('click', function () {
                $(this).tooltip('hide');
            });
            function find(id){
                for(var i=0;i<$('#assetTable').dataTable().api().data().length;i++){
                    if($('#assetTable').dataTable().api().data()[i]['assetId']==id)
                        return $('#assetTable').dataTable().api().data()[i];
                }
                return null;
            }
            function findGrup(obj,id){
                for(var i=0;i<obj.length;i++){
                    if(obj[i]['groupId']==id)
                        return true
                }
                return false;
            }
            function handleDragStart(e) {
                selectedRows=[];
                inGroup=[];
                notInGroup=[];
                this.style.opacity = '0.4';
                $('[id=checkAsset]:checked').each(function () {
                    selectedRows.push($(this).val());
                });
                if(selectedRows.indexOf(this.firstChild.firstElementChild.value)<0){
                    selectedRows.push(this.firstChild.firstElementChild.value);
                }
                for(var i=0;i<selectedRows.length;i++){
                    if(find(selectedRows[i])!=null){
                       if(findGrup(find(selectedRows[i])['groups'],$('#assetGroup').val())){
                           inGroup.push(find(selectedRows[i]));
                        }
                        else
                          notInGroup.push(find(selectedRows[i]));
                    }
                }
                selectedRows=[];
                for(var i=0;i<notInGroup.length;i++){
                    selectedRows.push(notInGroup[i]['assetId']);
                }
                dragSrcRow = this;
                srcTable = this.parentNode.parentNode.id

                e.dataTransfer.effectAllowed = 'move';
                e.dataTransfer.setData('text/plain', e.target.outerHTML);

            }
            function handleDragOver(e) {
                if (e.preventDefault) {
                    e.preventDefault(); // Necessary. Allows us to drop.
                }
                e.dataTransfer.dropEffect = 'move';
                return false;
            }



            function handleDrop(e) {
                if (e.stopPropagation) {
                    e.stopPropagation(); 
                }
                var dstTable = $(this.closest('table')).attr('id');
                if($('#assetGroup').val()!="NULL"){
                    if (srcTable !== dstTable) {
                        if (selectedRows.length > 0) {
                            $.ajax({
                                "type": "POST",
                                "url": "assignAssetsToGroup.json",
                                "data": {
                                    '${_csrf.parameterName}': "${_csrf.token}",
                                    'customerId': "${customerId}",
                                    'groupIds': $('#assetGroup').val(),
                                    'assetIds': selectedRows
                                },
                                "success": function () {
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html(alertText());
                                    $("#alertModal").modal("show");
                                    $('#assetGroupTable').dataTable().api().draw();
                                    $('#assetTable').dataTable().api().draw();
                                    $("#selectAllAsset").prop("checked", false);
                                }
                            })
                        }
                        else if(selectedRows.length==0 && inGroup.length>0){
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html(alertText());
                            $("#alertModal").modal("show");
                        }

                    }
                }
                else{
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="assetGroupMatching.alert1"/>");
                    $("#alertModal").modal("show");
                }
                return false;
            }
            function handleDragEnd(e) {
                this.style.opacity = '1.0';
            }
            function deleteAssetGroupRelation(assetId){
                var assetIdList=[];
                assetIdList.push(assetId);
                $.ajax({
                            "type": "POST",
                            "url": "deAllocateAssetsToGroup.json",
                            "data": {
                                '${_csrf.parameterName}': "${_csrf.token}",
                                'groupIds': $('#assetGroup').val(),
                                'assetIds': assetIdList
                            },
                            "success": function () {
                                $('#assetGroupTable').dataTable().api().draw();
                                $('#assetTable').dataTable().api().draw();
                            }
                        });
            }
            function deleteAssetGroupRelationMulti(){
                var assetIdList=[];
                $('[id=checkAssetsInGroup]:checked').each(function () {
                    assetIdList.push($(this).val());
                });
                if(assetIdList.length==0){
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="assetGroupMatching.alert2"/>");
                    $("#alertModal").modal("show");
                }
                else{
                    $.ajax({
                        "type": "POST",
                        "url": "deAllocateAssetsToGroup.json",
                        "data": {
                            '${_csrf.parameterName}': "${_csrf.token}",
                            'groupIds': $('#assetGroup').val(),
                            'assetIds': assetIdList
                               },
                            "success": function () {
                                $('#assetGroupTable').dataTable().api().draw();
                                $('#assetTable').dataTable().api().ajax.reload();
                                $("#selectAllAssetInGroup").prop("checked", false);
                                $('[data-toggle="tooltip"]').tooltip();
                                assetIdList=[];
                            }
                    });
                }
            }
            function alertText(){
            var html="";
            var grup=$('#assetGroup option:selected').text();
                if(notInGroup.length>0){
                    html+="<p>";
                    if(notInGroup.length==1){
                        html+=notInGroup[0]['ip']+" "+grup+" <spring:message code="assetGroupMatching.alert4"/></p>";
                    }
                    else{
                          for(var i=0;i<notInGroup.length-1;i++)
                              html+=notInGroup[0]['ip']+",";
                          html+=notInGroup[notInGroup.length-1]['ip']+" "+grup+" <spring:message code="assetGroupMatching.alert4"/></p>";
                    }   
                        
                }
                if(inGroup.length>0){
                    html+="<p>";
                    if(inGroup.length==1){
                        html+=inGroup[0]['ip']+" <spring:message code="assetGroupMatching.alert6"/></p>";
                    }
                    else{
                          for(var i=0;i<inGroup.length-1;i++)
                              html+=inGroup[0]['ip']+",";
                          html+=inGroup[inGroup.length-1]['ip']+" <spring:message code="assetGroupMatching.alert5"/></p>";
                    }   
                        
                }
             return html;   
            }
        </script>    
    </jsp:attribute>
    <jsp:body>
        <div class="row">
            <div class="col-lg-12">
                <div class="alert alert-success"><spring:message code="assetGroupMatching.alert3"/></div>
                <div class="row" style="padding-bottom: 10px;">
                    <div class="col-lg-1" style="padding-left: 25px;padding-top: 8px;width:120px">
                         <label ><spring:message code="addAssetGroup.group"/></label>
                    </div>
                <div class="col-lg-2" >
                    <select id="assetGroup" name="assetGroups" class="js-example-basic js-states form-control"  style="width: 100%;">
                                <c:if test="${empty groupId or groupId == 'NULL'}">
                                    <option value="NULL"><spring:message code="searchPanel.nullRecors"/></option>
                                </c:if>
                                <c:forEach items="${assetGroup}" var="group">
                                    <option value="<c:out value="${group.groupId}"/>"><c:out value="${group.name}"/></option>
                                </c:forEach>
                            </select>  
                </div>
                </div>
                <div class="col-lg-7">
                    <div style="text-align: center;text-align: center;border-style: solid;border-width: 3px;border-color: #d1ebec;">
                        <label style="font-size: 16px;"><spring:message code="main.theme.listAssets"/></label>
                    </div>
                    <br>
                    <table  class="table table-striped table-bordered table-hover" id="assetTable" style="width: 100%;">
                        <thead class="datatablesThead">
                            <tr>  
                                <th width="10px"><input type="checkbox" class="editor-active" id="selectAllAsset" onclick="selectAll2('selectAllAsset', 'checkAsset');" /></th>
                                <th><spring:message code="listAssets.asset"/></th>
                                <th><spring:message code="listAssets.groups"/></th> 
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="col-lg-5">
                        <div style="text-align: center;border-style: solid;border-width: 3px;border-color: #d1ebec;">
                            <label style="font-size: 16px;"><spring:message code="assetGroupMatching.assetgrouptable"/></label>
                        </div>
                         <br>
                        <table width="100%" class="table table-striped table-bordered table-hover" id="assetGroupTable" style="width: 100%;">
                            <thead class="datatablesThead">
                                <tr>  
                                    <th width="10px"><input type="checkbox" class="editor-active" id="selectAllAssetInGroup" onclick="selectAll2('selectAllAssetInGroup','checkAssetsInGroup');" /></th>
                                    <th style="width:90%;"><spring:message code="listAssets.asset"/></th>
                                    <th style="width:10%;"><a onClick="deleteAssetGroupRelationMulti()"  type="button" class="btn btn-danger btn-sm" data-toggle="tooltip" data-trigger="focus" data-placement="top" title="<spring:message code="assetGroupMatching.deallocateAssetMulti"/>"><i class="fas fa-times"></i></button></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </jsp:body>

</biznet:mainPanel>

