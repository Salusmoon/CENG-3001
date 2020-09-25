<%-- 
    Document   : listAssetGroups
    Created on : Apr 9, 2015, 5:39:09 PM
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<c:set var="context" value="${pageContext.request.contextPath}" />




<!DOCTYPE html>

<biznet:mainPanel viewParams="title,body">

    <jsp:attribute name="title">

        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li><li>
                <a class="title" href="../customer/listAssets.htm"><spring:message code="listAssets.title"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listAssetGroups.title"/></span>
            </li>
        </ul>

        <%--
          <c:choose>
              <c:when test="${customer == null}">                 
                  <spring:message code="listAssetGroups.title"/>
              </c:when>
              <c:otherwise>
                <c:out value="${customer.companyName}" /> || <spring:message code="listAssetGroups.title"/>
              </c:otherwise>
          </c:choose>
        --%>
    </jsp:attribute>

    <jsp:attribute name="button">

        <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
            <div class="dt-buttons">
                <p>
                    <a class="btn btn-primary btn-sm" href="addAssetGroup.htm?customerId=<c:out value="${customer.customerId}" />">

                        <spring:message code="listAssetGroups.addGroup"/></a>
                </p>
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
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        
        <style>
            
            
            #chartdiv {
      height: 100%;
    width: 100%;
    cursor: default !important;
}
            
         </style>
        <script src="${context}/resources/assets/global/plugins/vis-4.21.0/dist/vis-network.min.js"></script>  
        
        

        <script type="text/javascript">
            document.title = "<spring:message code="listAssetGroups.title"/> - BIZZY";        
            var oTable;
            var riskScoreCursorChart, riskScoreCursorAxis2, riskScoreCursorRange0, riskScoreCursorRange1, riskScoreCursorLabel, riskScoreCursorHand;
            $(document).ready(function () {
                oTable = $('#serverDatatables').dataTable({
                    "dom": "<'row'<'col-sm-10'f><'col-sm-2'l>>rtip",
                    "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                    "processing": true,
                    "serverSide": true,
                    "stateSave": true,
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
                    "columnDefs": [
                        { "width": "10px", "targets": 0 },
                        { "width": "120px", "targets": 1 },
                        { "width": "30px", "targets": 2 },
                        { "width": "20px", "targets": 3 },
                        { "width": "20px", "targets": 4 },
                        { "width": "150px", "targets": 5 },
                        { "width": "40px", "targets": 6 }
                    ],
                    "columns": [
                        {"data": function (data, type, dataToSet) {
                                var interval = ${maxScore} / 5;
                                if (interval === 0) {
                                    interval = 1;
                                }
                                if (data.score >= interval * 4) {
                                    return '<div class="riskScore riskLevel5"><b>' + data.score + '</b></div>';
                                }
                                if (data.score >= interval * 3) {
                                    return '<div class="riskScore riskLevel4"><b>' + data.score + '</b></div>';
                                }
                                if (data.score >= interval * 2) {
                                    return '<div class="riskScore riskLevel3"><b>' + data.score + '</b></div>';
                                }
                                if (data.score >= interval * 1) {
                                    return '<div class="riskScore riskLevel2"><b>' + data.score + '</b></div>';
                                }
                                if (data.score > -1) {
                                    return '<div class="riskScore riskLevel1"><b>' + data.score + '</b></div>';
                                }

                            },
                            "searchable": false
                        },
                        {"data": 'name', "orderable": false},
                        {"data": 'assetsCount', "searchable": false, "orderable": false},
                        {
                            "data": 'severity',
                            "render": function (data) {
                                if (data === null) {
                                        return '<i>-</i>';
                                } else {
                                    return data;
                                }
                            },
                            "defaultContent": "<i>-</i>",
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": 'createDate'},
                        {"data": 'description'},
                        {
                            "data": function (data) {
                                var html = '<div class="dropdown"><button class="btn btn-primary btn-sm dropdown-toggle" type="button" data-toggle="dropdown"><spring:message code="listScans.actions"/>&nbsp;<span class="caret"></span></button><ul class="dropdown-menu">';
                                html += '<li style="list-style: none;"><a  href="listAssets.htm?groupId=' + data.groupId + '" data-placement="top"><spring:message code="listAssetGroups.assets"/></a></li>  ';
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY') or hasRole('ROLE_COMPANY_MANAGER')">
                                html += '<li style="list-style: none;"><a  href="addAssetGroup.htm?action=update&groupId=' + data.groupId + '" data-placement="top"><spring:message code="generic.edit"/></a></li>  ';
                                html += '<li style="list-style: none;"><a  href="addAsset.htm?groupId=' + data.groupId + '" data-placement="top"><spring:message code="listAssetGroups.addAsset"/></a></li>  ';
                                html += '<li style="list-style: none;"><a  onClick="deleteRow(\'' + data.groupId + '\',\'' + data.assetsCount + '\', this)" data-placement="top"><spring:message code="generic.delete"/></a></li>  ';
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
                        "url": "loadAssetGroups.json",
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
            function deleteRow(groupId, count, deletedElement) {
                if (count !== '0') {
                    jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listAssetGroups.confirmDeleteNotEmpty"/>"), confirmDelete);
                } else {
                    jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listAssetGroups.confirmDelete"/>"), confirmDelete);
                }

                function confirmDelete() {
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteAssetGroup.json", {groupId: groupId, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function () {
                        oTable.fnDeleteRow(nRow);
                    }).fail(function () {

                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listAssetGroups.deleteFail"/>");
                        $("#alertModal").modal("show");
                    }).always(function () {
                    });
                }
            }

        
            
             var chart = am4core.create("chartdiv", am4plugins_forceDirected.ForceDirectedTree);
             var networkSeries = chart.series.push(new am4plugins_forceDirected.ForceDirectedSeries())
               

            $(document).ready(function () {
                $("g[aria-labelledby]").hide();
            })

            // viewAssetTree 
             var topScore = ${topScore};
            function decodeHtml(html) {
                var txt = document.createElement("textarea");
                txt.innerHTML = html;
                return txt.value;
            }
            
            $.post("listAssetGroups.json", {${_csrf.parameterName}: "${_csrf.token}"}).done(function (result) {
                    var graphValues=[];
                    
                    for (var x = 0; x < result.length; x++) {
                        var chartdata=[];
                        var name;
                        for (var y = 0; y < result.length; y++) {
                            if(result[x].groupId === result[y].parentGroupId){
                                chartdata.push({name: result[y].name, id: result[y].groupId, value: result[y].scoresInYear[0]})
                            }    
                        };

                        if(result[x].parentGroupId===null){
                                graphValues.push({   
                                "name": decodeHtml(result[x].name)+ "\n\ \n\ Risk Puanı : " + result[x].scoresInYear[0],     
                                "children": chartdata});
                                
                        }
                        chartdata=[];
                    }
                    chart.data = graphValues;

                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    if (riskScoreCursorChart !== undefined)
                        riskScoreCursorChart.dispose();
                    riskScoreCursorChart = am4core.create("riskScoreCursor", am4charts.GaugeChart);
                    riskScoreCursorChart.innerRadius = am4core.percent(62);

                    /**
                     * Axis for ranges
                     */

                    colorSet = new am4core.ColorSet();

                    riskScoreCursorAxis2 = riskScoreCursorChart.xAxes.push(new am4charts.ValueAxis());
                    riskScoreCursorAxis2.min = 0;
                    riskScoreCursorAxis2.max = topScore;
                    riskScoreCursorAxis2.renderer.innerRadius = 10;
                    riskScoreCursorAxis2.strictMinMax = true;
                    riskScoreCursorAxis2.renderer.labels.template.disabled = true;
                    riskScoreCursorAxis2.renderer.ticks.template.disabled = true;
                    riskScoreCursorAxis2.renderer.grid.template.disabled = true;

                    riskScoreCursorRange0 = riskScoreCursorAxis2.axisRanges.create();
                    riskScoreCursorRange0.value = 0;
                    riskScoreCursorRange0.endValue = 50;
                    riskScoreCursorRange0.axisFill.fillOpacity = 1;
                    riskScoreCursorRange0.axisFill.fill = colorSet.getIndex(0);

                    var riskScoreCursorFm = new am4core.LinearGradientModifier();
                    riskScoreCursorFm.brightnesses = [-0.8, 1, -0.8];
                    riskScoreCursorFm.offsets = [0, 0.5, 1];
                    riskScoreCursorRange0.axisFill.fillModifier = riskScoreCursorFm;

                    riskScoreCursorRange1 = riskScoreCursorAxis2.axisRanges.create();
                    riskScoreCursorRange1.value = 50;
                    riskScoreCursorRange1.endValue = 100;
                    riskScoreCursorRange1.axisFill.fillOpacity = 1;
                    riskScoreCursorRange1.axisFill.fill = colorSet.getIndex(2);
                    var riskScoreCursorFm2 = new am4core.LinearGradientModifier();
                    riskScoreCursorFm2.brightnesses = [-0.2, 0.2, -0.2];
                    riskScoreCursorFm2.offsets = [0, 0.5, 1];
                    riskScoreCursorRange1.axisFill.fillModifier = riskScoreCursorFm2;

                    riskScoreCursorLabel = riskScoreCursorChart.radarContainer.createChild(am4core.Label);
                    riskScoreCursorLabel.isMeasured = false;
                    riskScoreCursorLabel.fontSize = 25;
                    riskScoreCursorLabel.x = am4core.percent(50);
                    riskScoreCursorLabel.y = am4core.percent(100);
                    riskScoreCursorLabel.horizontalCenter = "middle";
                    riskScoreCursorLabel.verticalCenter = "bottom";
                    riskScoreCursorLabel.text = "50%";

                    riskScoreCursorHand = riskScoreCursorChart.hands.push(new am4charts.ClockHand());
                    riskScoreCursorHand.axis = riskScoreCursorAxis2;
                    riskScoreCursorHand.innerRadius = am4core.percent(30);
                    riskScoreCursorHand.startWidth = 10;
                    riskScoreCursorHand.pin.disabled = true;
                    riskScoreCursorHand.value = 50;
                    
                     $(document).ready(function () {
                $("g[aria-labelledby]").hide();
            })
                });
                
               am4core.ready(function() {
              

               // Themes begin
               am4core.useTheme(am4themes_animated);
               // Themes end
            
               networkSeries.dataFields.value = "value";
               networkSeries.dataFields.name = "name";
               networkSeries.dataFields.children = "children";
               networkSeries.nodes.template.tooltipText = "{name}";
               networkSeries.nodes.template.fillOpacity = 1;
               networkSeries.nodes.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
               networkSeries.nodes.template.showHandOnHover = true;
               networkSeries.nodes.template.interactionsEnabled = true;
               networkSeries.nodes.template.label.text = "[black bold]{name}[/]"
               networkSeries.nodes.template.label.wrap = true;
               networkSeries.fontSize = 12;
               networkSeries.minRadius = 50;
               networkSeries.maxRadius = 100;
               //networkSeries.maxLevels = 3;


               networkSeries.links.template.strokeWidth = 1;

               var hoverState = networkSeries.links.template.states.create("hover");
               hoverState.properties.strokeWidth = 3;
               hoverState.properties.strokeOpacity = 1;
               
               networkSeries.nodes.template.events.on("over" , function(event) {
                 event.target.dataItem.childLinks.each(function(link) {
                   link.isHover = true;
                 })
                 if (event.target.dataItem.parentLink) {
                   event.target.dataItem.parentLink.isHover = true;
                 }

               })
               networkSeries.nodes.template.events.on("hit", function(event) { 
                     if (event.target.dataItem.level === 1) {
                         showModal(event.target.dataItem.dataContext.id, ${topScore});
                         
                     }
               })
               
               networkSeries.nodes.template.events.on("out", function(event) {
                 event.target.dataItem.childLinks.each(function(link) {
                   link.isHover = false;
                 })
                 if (event.target.dataItem.parentLink) {
                   event.target.dataItem.parentLink.isHover = false;
                 }
               })
               
               }); // end am4core.ready()


        </script>
    <jsp:include page="include/viewAssetModal.jsp" />              
    </jsp:attribute>    

    <jsp:body>

        <div class="portlet-body" >
            <div>
                <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" style="table-layout:fixed;width: 100%;">
                    <thead class="datatablesThead">
                        <tr>                                                             
                            <th><spring:message code="listAssets.score"/></th>
                            <th><spring:message code="listAssetGroups.name"/></th>
                            <th><spring:message code="listAssetGroups.assetsCount"/></th>
                            <th><spring:message code="addAssetGroup.severity"/></th>
                            <th><spring:message code="listAssetGroups.creationDate"/></th>  
                            <th><spring:message code="listAssets.description"/></th>
                            <th> <div style="min-width: 150px;"></div> </th>
                    </tr>
                    </thead>                                 
                </table>    

            </div>
        </div>
        <br>
    
        <!-- viewAssetTree divi -->
        
         <div class="row">
            <div class="col-lg-12">
                <h3 class="page-title"><spring:message code="listAssetGroups.Tree"/></h3>
            </div>
            <!-- /.col-lg-12 -->
        </div>        
       
      
        
        
        
         <div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="portlet light bordered shadow-soft" >
                       
                            <div class="portlet-body text-center" id="assetGroupTreeDiv" >
                                
                                
                                <div id="chartdiv" style=" height: 700px; width: 100%;">

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <style>
                .dt-buttons {
                    float: none !important;
                    margin-top: 0% !important;
                    display: inline-table;
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
                    margin-top: -76px;
                }
            </style>
   
    </jsp:body>
</biznet:mainPanel>
