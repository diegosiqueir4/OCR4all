<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<t:html>
    <t:head>
        <title>OCR4All - Page Overview</title>

        <script type="text/javascript">
            $(document).ready(function() {
                // Initialize image boxes
                $('.materialboxed').materialbox();

                // Function to load images on overview page via AJAX
                function loadImage(el) {
                    var dataType = $(el).parents('ul.collapsible').first().attr('data-type');
                    // Skip loading image, if it was loaded previously
                    if( $(el).find('img').attr('src') ) {
                        return;
                    }

                    var pageId  = $('input[name="pageId"]').val();
                    var imageId = $(el).find(".collapsible-header span").first().attr('data-img');
                    var ajaxURL = "ajax/image/" + dataType;
                    var ajaxParams = { "pageId" : pageId, "imageId" : imageId, "width" : 518};
                    if(  dataType == "line" ) {
                        var segmentId = $(el).parents(".collapsible").eq(1).children("li.active").find(".collapsible-header span").first().text();
                        $.extend(ajaxParams, { "segmentId" : segmentId });
                    }

                    // Load requested image and handle error in case of failure
                    $.get( ajaxURL, ajaxParams )
                    .done(function( data ) {
                        if( data === '' ) {
                            $(el).find('i[data-info="broken-image"]').first().remove();
                            $(el).find('img').first().after('<i class="material-icons" data-info="broken-image">broken_image</i>');
                        }
                        else {
                            $(el).find('i[data-info="broken-image"]').first().remove();
                            $(el).find('img').first().attr('src', 'data:image/jpeg;base64, ' + data);
                        }
                    })
                    .fail(function( data ) {
                        $(el).find('i[data-info="broken-image"]').first().remove();
                        $(el).find('img').first().after('<i class="material-icons" data-info="broken-image">broken_image</i>');
                    })
                }

                // Initialize collapsible elements
                $('.collapsible[data-type]').collapsible({
                    onOpen: function(el) { loadImage(el); },
                });

                loadImage($('.collapsible[data-type="page"]').find('li').eq(0));
                $('.collapsible[data-type="page"]').collapsible('open', 0);



                $('input.autocomplete').autocomplete({
                      data: {

                                                                         "jQuery": null,

                                                                         "JavaScript": 'https://www.jquery-az.com/wp-content/uploads/2017/12/favicon-32x32.png',

                                                                         "CSS": null,

                                                                         "HTML": null,

                                                                         "Bootstrap": 'https://www.jquery-az.com/wp-content/uploads/2017/12/favicon-32x32.png',

                                                                         "Java": null,

                                                                         "Python": null,

                                                                       },

                    });




                <%--<c:choose>--%>
                    <%--&lt;%&ndash; Open Gray image if it is set in session &ndash;%&gt;--%>
                    <%--<c:when test='${imageType == "Gray"}'>--%>
                        <%--loadImage($('.collapsible[data-type="page"]').find('li').eq(2));--%>
                        <%--$('.collapsible[data-type="page"]').collapsible('open', 2);--%>
                    <%--</c:when>--%>
                    <%--&lt;%&ndash; Else open Binary image as default &ndash;%&gt;--%>
                    <%--<c:otherwise>--%>
                        <%--loadImage($('.collapsible[data-type="page"]').find('li').eq(1));--%>
                        <%--$('.collapsible[data-type="page"]').collapsible('open', 1);--%>
                    <%--</c:otherwise>--%>
                <%--</c:choose>--%>
            });

            function prevFunction() {
                var searchParams = new URLSearchParams(window.location.search);
                var pageidcoerce = (+searchParams.get("pageId")) - 1;
                var pageid = ("0000" + pageidcoerce).slice(-4);
                if (pageid !== "0000") {
                    if (searchParams.get("len")==null){
                        var newLocation = window.location.href.split("?")[0] + "?pageId=" + pageid;
                    } else {
                        var newLocation = window.location.href.split("&")[0] + "&pageId=" + pageid;
                    }
                    window.location.href = newLocation;
                }
            };

            function nextFunction() {
                var searchParams = new URLSearchParams(window.location.search);
                var pageidcoerce = (+searchParams.get("pageId")) + 1;
                var pageid = ("0000" + pageidcoerce).slice(-4);
                if (!searchParams.has('len')){
                    picListL = $.get("ajax/overview/list", function(data){
                    return data;
                    });
                    var length = Object.keys(picListL).length;
                    var newLocation = window.location.href.split("?")[0] + "?len=" + length +"&pageId=" + pageid;
                } else {
                    var newLocation = window.location.href.split("&")[0] + "&pageId=" + pageid;
                }
                if (pageidcoerce !== (length+1) && pageidcoerce !== (+searchParams.get("len")+1)){
                    window.location.href = newLocation;
                }
            };





        </script>
    </t:head>
    <t:body heading="Page Overview">
        <input id="pageId" name="pageId" type="hidden" value="${param.pageId}" />
        <div class="container">
         <div class="section">
                        <div class="row">
                            <div class="col s4 prev-area" onclick="prevFunction()">
                                <button class="pn-button"><i class="material-icons">chevron_left</i> previous</button>
                            </div>

                            <div class="input-field col s4">
                               <i class="material-icons prefix right" onclick="openAuto">details</i>
                                <input type="text" id="autocomplete_pages" class="autocomplete">
                                <label for="autocomplete pages">Go to Page</label>
                            </div>

                            <div class="col s4 next-area" onclick="nextFunction()">
                                <button class="pn-button">next <i class="material-icons">chevron_right</i></button>
                            </div>
                        </div>
            </div>
            <div class="section">
                <table class="striped centered">
                    <thead>
                        <tr>
                            <th>Page Identifier</th>
                            <th>Preprocessing</th>
                            <th>Noise Removal</th>
                            <th>Segmentation</th>
                            <th>Region Extraction</th>
                            <th>Line Segmentation</th>
                            <th>Recognition</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${pageOverview.pageId}</td>
                            <td><c:choose><c:when test="${pageOverview.preprocessed == 'true'}"><i class="material-icons green-text">check</i></c:when><c:otherwise><i class="material-icons red-text">clear</i></c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${pageOverview.despeckled == 'true'}"><i class="material-icons green-text">check</i></c:when><c:otherwise><i class="material-icons red-text">clear</i></c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${pageOverview.segmented == 'true'}"><i class="material-icons green-text">check</i></c:when><c:otherwise><i class="material-icons red-text">clear</i></c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${pageOverview.segmentsExtracted == 'true'}"><i class="material-icons green-text">check</i></c:when><c:otherwise><i class="material-icons red-text">clear</i></c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${pageOverview.linesExtracted == 'true'}"><i class="material-icons green-text">check</i></c:when><c:otherwise><i class="material-icons red-text">clear</i></c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${pageOverview.recognition == 'true'}"><i class="material-icons green-text">check</i></c:when><c:otherwise><i class="material-icons red-text">clear</i></c:otherwise></c:choose></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="section">
                <div class="row">
                    <div class="col s6">
                        <h4 class="center">Images</h4>
                        <ul id="images" class="collapsible" data-collapsible="accordion" data-type="page">
                            <li>
                                <div class="collapsible-header"><i class="material-icons">image</i><span data-img="Original">Original</span></div>
                                <div class="collapsible-body">
                                    <img class="materialboxed centered" width="75%" />
                                </div>
                            </li>
                            <li>
                                <div class="collapsible-header"><i class="material-icons">image</i><span data-img="Binary">Binary</span></div>
                                <div class="collapsible-body">
                                    <img class="materialboxed centered" width="75%" />
                                </div>
                            </li>
                            <li>
                                <div class="collapsible-header"><i class="material-icons">image</i><span data-img="Gray">Gray</span></div>
                                <div class="collapsible-body">
                                    <img class="materialboxed centered" width="75%" />
                                </div>
                            </li>
                            <li>
                                <div class="collapsible-header"><i class="material-icons">image</i><span data-img="Despeckled">Noise Removal</span></div>
                                <div class="collapsible-body">
                                    <img class="materialboxed centered" width="75%" />
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div class="col s6">
                        <h4 class="center">Segments</h4>
                        <ul id="segments" class="collapsible" data-collapsible="accordion" data-type="segment">
                            <c:forEach items="${segments}" var="seg">
                            <li>
                                <div class="collapsible-header"><i class="material-icons">art_track</i><span data-img="${seg.key}">${seg.key}</span></div>
                                <div class="collapsible-body">
                                    <img class="materialboxed centered" width="75%" />
                                    <ul id="lines_${seg.key}" class="collapsible" data-collapsible="accordion" data-type="line">
                                        <c:forEach var="line" items="${seg.value}">
                                            <li>
                                                <div class="collapsible-header"><i class="material-icons">short_text</i><span data-img="${line}">${line}</span></div>
                                                <div class="collapsible-body">
                                                    <img class="materialboxed centered" width="75%" />
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </t:body>
</t:html>
