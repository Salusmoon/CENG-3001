<%-- 
    Document   : listAssetProperties
    Created on : Oct 18, 2018, 1:34:28 PM
    Author     : gurkan.gezgen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>


<!DOCTYPE html>
<biznet:mainPanel viewParams="title,search,body">

    <jsp:attribute name="title">
        <ul class="page-breadcrumb breadcrumb"> <li>
                <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
            </li>
            <li>
                <span class="title2"><spring:message code="listAssets.assetProps"/></span>
            </li>
        </ul>
    </jsp:attribute>

    <jsp:attribute name="search">
        <biznet:searchpanel tableName="oTable">
            <jsp:body>
                <div class="col-lg-12" style="left:-2%;">

                    <div class="col-lg-3" >
                        <div class="col-lg-4">
                            <label class="control-label" id="labelAsset" ><b><spring:message code="listAssets.asset"/></b></label>
                        </div>
                        <div class="col-lg-8">
                            <input class="form-control" id="inputAsset" name="inputAsset" placeholder=""> 
                        </div>
                    </div>

                    <div class="col-lg-3" >
                        <div class="col-lg-4">
                            <label class="control-label" id="labelAssetProps" ><b><spring:message code="listAssets.assetProps"/></b></label>
                        </div>
                        <div class="col-lg-8">
                            <input class="form-control" id="inputAssetProps" name="inputAssetProps" placeholder=""> 
                        </div>
                    </div>

                </div>
            </jsp:body>
        </biznet:searchpanel>
    </jsp:attribute>

    <jsp:attribute name="button">

        <div class="portlet-body">
            <div class="dt-buttons">
                <p style="margin-top:-32px">
                    <a class="btn btn-primary btn-sm" id="addAssetPropBtn" onclick="addNewAssetProp()"><spring:message code="listAssetProperties.addNewAssetProp"/></a>
                </p>
            </div>
        </div>


    </jsp:attribute>

    <jsp:attribute name="script">

        <style>
            .btn.active
            {
                color: black;
                background-color:white;
            }
            
           #propertyTable_processing
           {
            margin-top: -5%;      
            z-index: 1200;              
           }
        </style>

        <script type="text/javascript">
            document.title = "<spring:message code="listAssets.assetProps"/> - BIZZY";
            var assetPropertyGraph;
            $(document).ready(function (){

            function am4themes_bizzyTheme(target) {
            if (target instanceof am4core.ColorSet) {
            target.list = [
                    am4core.color("#456173"),
                    am4core.color("#cacaca"),
                    am4core.color("#1b3c59"),
                    am4core.color("#e6b31e"),
                    am4core.color("#f95959"),
                    am4core.color("#f73859"),
                    am4core.color("#f1d18a"),
                    am4core.color("#e6b31e"),
                    am4core.color("#f1e58a"),
                    am4core.color("#344652"),
                    am4core.color("#101f2a"),
                    am4core.color("#ffb143")
            ];
            }
            }
            am4core.useTheme(am4themes_animated);
                    am4core.useTheme(am4themes_bizzyTheme);
                    am4core.options.commercialLicense = true;
                    /* ÖZELLİKLERİN VARLIKLARA GÖRE DAĞILIMI GRAFİĞİ */
                    assetPropertyGraph = am4core.create("assetPropertyGraph", am4charts.XYChart3D);
                    assetPropertyGraph.legend = new am4charts.Legend();
                    //assetPropertyGraph.legend.labels.template.text = "Series: [bold]{categoryX}[/]";

                    assetPropertyGraph.data = [<c:forEach var="assetProperty" varStatus="status" items="${assetPropertyList}">
                <c:if test = "${assetProperty.assetCount > 0}">
                    {"tagName": decodeHtml('<c:out value="${assetProperty.parameter}"/>'), "tagCount":'<c:out value="${assetProperty.assetCount}"/>', color: colors['<c:out value="${status.index}"/>']
                    }
                    ,
                </c:if>
            </c:forEach>
                    ];
            // Create axes
            var categoryAxis = assetPropertyGraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "tagName";
            categoryAxis.renderer.labels.template.rotation = 315;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.rotation = 270;
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";
            categoryAxis.renderer.inversed = true;
            var label = categoryAxis.renderer.labels.template;
            label.wrap = true;
            label.maxWidth = 120;
            assetPropertyGraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var valueAxis = assetPropertyGraph.yAxes.push(new am4charts.ValueAxis());
            // Create series

            var series = assetPropertyGraph.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueY = "tagCount";
            series.dataFields.categoryX = "tagName";
            series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(40);
            series.columns.template.height = am4core.percent(40);
            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");
            columnTemplate.adapter.add("fill", function (fill, target) {
                return assetPropertyGraph.colors.getIndex(target.dataItem.index);
            });
            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return assetPropertyGraph.colors.getIndex(target.dataItem.index);
            })
            assetPropertyGraph.cursor = new am4charts.XYCursor();
            assetPropertyGraph.cursor.lineX.strokeOpacity = 0;
            assetPropertyGraph.cursor.lineY.strokeOpacity = 0;
            assetPropertyGraph.events.on("beforedatavalidated", function (ev) {
                assetPropertyGraph.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function(ev) {
            var url = '../customer/listVulnerabilities.htm?effectValue=' + ev.target.dataItem.dataContext.type;
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
            },
                    this
                    );
            }
            );
            function addNewAssetProp() {

                $('#propModal').modal('show');
            }
             function cancelEdit(){
                document.getElementById("statusErrorPTag").style.visibility = "hidden";
                document.getElementById("assetPropertyName").value="";
                
            }
            function checkAvailibility() {
             var textAre = document.getElementById("assetPropertyName");
              if (!textAre.value || textAre.value.length === 0) {
                    document.getElementById("statusErrorPTag").style.visibility = "visible";
                }
            else{
                    document.getElementById("statusErrorPTag").style.visibility = "hidden";
                $.post("updateAssetProperty.json", {
                    'assetProperty': $("#assetPropertyName").val(),
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function () {
                    oTable.fnDraw();
                    $('#propModal').modal('hide'); 
                    document.getElementById("assetPropertyName").value = "";
                }).fail(function () {
                });
            }
        }
            function deleteRow(parameter, count, deletedElement) {
                if (count !== '0') {
                    jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="listAssetProperties.confirmDeleteNotEmpty"/>"), confirmDelete);
                } else {
                    jsInformationOkCancelModalFunction(decodeHtml("<spring:message code="generic.confirmDelete"/>"), confirmDelete);
                }
                function confirmDelete() {
                    var nRow = $(deletedElement).parents('tr')[0];
                    $.post("deleteAssetProperty.json", {parameter: parameter, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
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
            var oTable;
            oTable = $('#propertyTable').dataTable({
                "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                "dom": "<'row'<'col-sm-1'f><'col-sm-11'l>>rtip",
                "processing": true,
                "serverSide": true,
                "searching": false,
                "stateSave": true,
                "scrollX": true,
                "columnDefs": [
                        { "width": "50%", "targets": 0 },
                        { "width": "10%", "targets": 1 },
                        { "width": "20%", "targets": 2 },
                        { "width": "20%", "targets": 3 }
                    ],
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
                "columns": [
                    {"data": function (data, type, row) {
                            if (data.assetCount > 0) {
                                return '<a data-toggle="tooltip" data-placement ="top" title ="<spring:message code="generic.detail"/>" onclick="showModal(\'' + data.parameter + '\')">' + data.parameter + '</a> ';
                            } else {
                                return data.parameter;
                            }
                        }, "searchable": false, "orderable": false
                    },
                    {"data": 'assetCount'},
                    {"data": function (data, type, dataToSet) {
                            if (data.createdBy === null) {
                                return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                            } else {
                                return '<div style ="height:25px;">' + data.createdBy + '</div>';
                            }
                        },
                        "searchable": false,
                        "orderable": false
                    },
                    {"data": 'createDate'},
                    {"data": function (data, type, dataToSet) {
                            var html = '<button onClick="deleteRow(\'' + data.parameter + '\',\'' + data.assetCount + '\', this)" name="delete" type="button" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="<spring:message code="generic.delete"/>"><i class="fas fa-times"></i></button>';
                            return html;
                        }, "searchable": false, "orderable": false
                    }
                ],
                "order": [2, 'desc'],
                "ajax": {
                    "type": "POST",
                    "url": "loadAssetProperties.json",
                    "data": function (d) {
                        d.${_csrf.parameterName} = "${_csrf.token}";
                        d.inputAsset = $('#inputAsset').val();
                        d.inputAssetProps = $('#inputAssetProps').val();
                    },
                    // error callback to handle error
                    "error": function (jqXHR, textStatus, errorThrown) {
                        console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);

                        $("#alertModalBody").empty();
                        $("#alertModalBody").html("<spring:message code="listQualysScans.tableError"/>");
                        $("#alertModal").modal("show");
                    }
                },
                "fnDrawCallback": function (oSettings) {
                    $('[data-toggle="tooltip"]').tooltip();
                },
                "initComplete": function (settings, json) {
                    oTable.fnAdjustColumnSizing();
                    $('[data-toggle="tooltip"]').tooltip();
                }
            });
            var colors = ["#FF0F00", "#0D8ECF", "#04D215", "#FCD202", "#8A0CCF", "#F8FF01", "#CD0D74", "#FF6600", "#0D52D1", "#B0DE09"];
            function showModal(parameter) {
                $.post('getAssetPropertyDetails.json', {
                    'parameter': parameter,
            ${_csrf.parameterName}: "${_csrf.token}"
                }).done(function (data) {
                    var table = document.getElementById("assetTable");
                    var body = document.createElement("tbody");
                    var tr1 = document.createElement("tr");
                    var td1 = document.createElement("td");
                    td1.innerHTML = '<spring:message code="addAsset.ip"/>';
                    var td2 = document.createElement("td");
                    td2.innerHTML = '<spring:message code="listAssets.hostname"/>';
                    tr1.appendChild(td1);
                    tr1.appendChild(td2);
                    body.appendChild(tr1);
                    for (var i = 0; i < data.length; i++) {
                        var tr = document.createElement("tr");
                        var td1 = document.createElement("td");
                        td1.innerHTML = <c:out value = "data[i].ip"/>;
                        var td2 = document.createElement("td");
                        td2.innerHTML = <c:out value = "data[i].hostname"/>;
                        tr.appendChild(td1);
                        tr.appendChild(td2);
                        body.appendChild(tr);
                    }
                    table.appendChild(body);
                    $('#assetModal').modal('show');
                });
            }
            $('#assetModal').on("hidden.bs.modal", function () {
                $("#assetTable tbody").empty();
            });
        </script>
        
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />

    </jsp:attribute>


    <jsp:body>
        
        

        <table class="table table-striped table-bordered table-hover" id="propertyTable" class="serverDatatables_process">

            <thead class="datatablesThead">
                <tr>
                    <th style="vertical-align: middle; min-width: 500px; min-height: 42px;"><spring:message code="listAssetProperties.assetProperty"/></th>
                    <th style="vertical-align: middle; min-width: 100px; min-height: 42px;"><spring:message code="listAssetProperties.totalAsset"/></th>
                    <th style="vertical-align: middle; min-width: 200px; min-height: 42px;"><spring:message code="listCategories.addedBy"/></th>
                    <th style="vertical-align: middle; max-width: 200px; min-height: 42px;"><spring:message code="listTags.additionDate"/></th>
                    <th width="100px"><div style="min-width: 100px;"></div></th>  
                </tr>
            </thead>     

        </table> 


        <div class="modal fade" id="propModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
            <div class="modal-dialog" style="height: 100%; overflow-x: hidden; width: 50%;"> 
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><b><spring:message code="listAssetProperties.addNewAssetProp"/></b></h4>
                    </div>

                    <div id="modalBody">

                        <div class="col-lg-12">
                            <div class="row" style="padding-top: 10px;"></div>
                            <div class="row">
                                <div class =" col-lg-3">
                                    <label class="control-label" ><b><spring:message code="listAssetProperties.propName"/></b></label>    
                                </div>
                                    <div class =" col-lg-9">
                                        <input class="form-control" id="assetPropertyName"  placeholder="">   
                                        <div class="form-group" style="position: relative;bottom: 15px;">
                                            <p id="statusErrorPTag" style="color:red;visibility:hidden">
                                                <br><b><spring:message code="listTags.fillFieldMessage"/></b></p>
                                        </div> 
                                    </div>
                            </div>
                            <div class="row" style="padding-top: 10px;"></div>
                        </div>
                        <div class="modal-footer"> 
                            <br>
                            <button type="button" class="btn btn-primary" onclick="checkAvailibility()"><spring:message code="listTags.add"/></button> 

                            <button type="button" class="btn btn-default" onclick="cancelEdit()" data-dismiss="modal"><spring:message code="listTags.cancel"/></button> 
                        </div> 
                    </div> 
                </div> 
            </div>
        </div> 

        <div class="modal fade" id="assetModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
            <div class="modal-dialog" style="height: 90%; overflow-x: hidden; width: 50%;"> 
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><spring:message code="listAssetProperties.assetList"/></h4>
                    </div>
                    <div id="modalBody">
                        <div id="detailAsset">
                            <div class="col-lg-12">
                                <table width="100%" id="assetTable" class="table table-striped table-bordered table-hover" style="width: 100%; margin-top: 1%;">                            
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer"> 
                            <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.close"/></button> 
                        </div> 
                    </div> 
                </div> 
            </div>
        </div>                

        <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
            <div class="row">
                <div class="col-lg-12">
                    <div class="portlet light bordered shadow-soft">
                        <div class="portlet-title">
                            <div class="caption">
                                <i class="icon-equalizer font-dark hide"></i>
                                <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="listAssetProperties.assetByProps"/></span>
                                <!--     <div class="bizzy-help-tip"   >
                                        <p> &bull;</p>
                                    </div> !--> 

                            </div>
                        </div>
                        <div class="portlet-body">
                            <div id="assetPropertyGraph" style="width: 100%;height:500px"></div>
                        </div>
                    </div>
                </div>
            </div>

        </sec:authorize>
        <style>
            .dt-buttons {
                margin-top: 0% !important;
                display: inline;
                position: inherit !important;
                z-index: 1;
                left: 6%;
                float: none !important;
            } 
            .dataTables_length {
                margin-top: 0px !important;
                display: inline;
                position: relative;
                float: right;
                z-index: 2;
            }
            .dataTables_wrapper {
                margin-top: -3%;
            }
            .table{
                width: 100% !important;
            }
        </style>

    </jsp:body>



</biznet:mainPanel>
