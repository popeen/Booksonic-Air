<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <style type="text/css">
        #progressBar {width: 350px; height: 10px; border: 1px solid black; display:none;}
        #progressBarContent {width: 0; height: 10px; background: url("<c:url value="/icons/default_light/progress.png"/>") repeat;}
        #randomPlayQueue td { padding: 0 5px; }
    </style>
    <script type="text/javascript" src="<c:url value='/dwr/interface/transferService.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/dwr/engine.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/dwr/util.js'/>"></script>

    <script type="text/javascript">
        function refreshProgress() {
            transferService.getUploadInfo(updateProgress);
        }

        function updateProgress(uploadInfo) {

            var progressBar = document.getElementById("progressBar");
            var progressBarContent = document.getElementById("progressBarContent");
            var progressText = document.getElementById("progressText");


            if (uploadInfo.bytesTotal > 0) {
                var percent = Math.ceil((uploadInfo.bytesUploaded / uploadInfo.bytesTotal) * 100);
                progressBarContent.style.width = parseInt(percent * 3.5) + 'px';
                progressText.innerHTML = percent + "<fmt:message key="more.upload.progress"/>";
                progressBar.style.display = "block";
                progressText.style.display = "block";
                window.setTimeout("refreshProgress()", 1000);
            } else {
                progressBar.style.display = "none";
                progressText.style.display = "none";
                window.setTimeout("refreshProgress()", 5000);
            }
        }

        // From Modernizr
        // See: https://modernizr.com/
        function isLocalStorageEnabled() {
            var mod = 'modernizr';
            try {
                localStorage.setItem(mod, mod);
                localStorage.removeItem(mod);
                return true;
            } catch(e) {
                return false;
            }
        }
         
		function correctPodcastUrl(){
            document.getElementById("podcastUrl").innerHTML = (window.location).toString().replace('more', 'podcast').replace('.view?', '');
        }

    </script>

    <style type="text/css">
        .more-shortcut {
            padding: 0 15px;
        }
    </style>

</head>
<body class="mainframe bgcolor1" onload="correctPodcastUrl()">

<h1>
    <img src="<spring:theme code='moreImage'/>" alt=""/>
    <span style="vertical-align: middle"><fmt:message key="more.title"/></span>
</h1>

<a href="https://airsonic.github.io/docs/apps/" target="_blank" rel="noopener noreferrer"><img alt="Apps" src="<c:url value='/icons/default_light/apps.png'/>" style="float: right;margin-left: 3em; margin-right: 3em"/></a>

<h2>
    <img src="<spring:theme code='androidImage'/>" alt=""/>
    <span style="vertical-align: middle"><fmt:message key="more.apps.title"/></span>
</h2>
<fmt:message key="more.apps.text"/>


<h2>
    <img src="<spring:theme code='statusSmallImage'/>" alt=""/>
    <span style="vertical-align: middle"><fmt:message key="more.status.title"/></span>
</h2>
<fmt:message key="more.status.text"/>

<h2>
    <img src="<spring:theme code='podcastImage'/>" alt=""/>
    <span style="vertical-align: middle"><fmt:message key="more.podcast.title"/></span>
</h2>
<fmt:message key="more.podcast.text"/>

<c:if test="${model.user.uploadRole}">

    <h2>
        <img src="<spring:theme code='uploadImage'/>" alt=""/>
        <span style="vertical-align: middle"><fmt:message key="more.upload.title"/></span>
    </h2>

    <form method="post" enctype="multipart/form-data" action="upload.view?${_csrf.parameterName}=${_csrf.token}">
        <table>
            <tr>
                <td><fmt:message key="more.upload.source"/></td>
                <td colspan="2"><input type="file" id="file" name="file" size="40"/></td>
            </tr>
            <tr>
                <td><fmt:message key="more.upload.target"/></td>
                <td><input type="text" id="dir" name="dir" size="37" value="${model.uploadDirectory}"/></td>
                <td><input type="submit" value="<fmt:message key='more.upload.ok'/>"/></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="checkbox" checked name="unzip" id="unzip"/>
                    <label for="unzip"><fmt:message key="more.upload.unzip"/></label>
                </td>
            </tr>
        </table>
    </form>


    <p class="detail" id="progressText"/>

    <div id="progressBar">
        <div id="progressBarContent"></div>
    </div>

</c:if>

<a name="shortcuts"></a>
<h2>
    <img src="<spring:theme code='keyboardImage'/>" alt=""/>
    <span style="vertical-align: middle"><fmt:message key="more.keyboard.title"/></span>
</h2>
<fmt:message key="more.keyboard.text"/>
<table class="indent music" style="width:inherit">
    <tr>
        <th colspan="2"><fmt:message key="more.keyboard.playback"/></th>
        <th colspan="2"><fmt:message key="more.keyboard.navigation"/></th>
        <th colspan="2"><fmt:message key="more.keyboard.general"/></th>
    </tr>
    <tr>
        <td class="more-shortcut">Space</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.playpause"/></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> h</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.home"/></td>
        <td class="more-shortcut">/</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.search"/></td>
    </tr>
    <tr>
        <td class="more-shortcut">&#8592;</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.previous"/></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> p</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.playlists"/></td>
        <td class="more-shortcut">m</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.sidebar"/></td>
    </tr>
    <tr>
        <td class="more-shortcut">&#8594;</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.next"/></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> o</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.podcasts"/></td>
        <td class="more-shortcut">q</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.playqueue"/></td>
    </tr>
    <tr>
        <td class="more-shortcut">&ndash;</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.volumedown"/></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> s</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.settings"/></td>
        <td class="more-shortcut">?</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.shortcuts"/></td>
    </tr>
    <tr>
        <td class="more-shortcut">+</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.volumeup"/></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> t</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.starred"/></td>
        <td></td><td></td>
    </tr>
    <tr>
        <td></td><td></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> r</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.more"/></td>
        <td></td><td></td>
    </tr>
    <tr>
        <td></td><td></td>
        <td class="more-shortcut">g <fmt:message key="more.keyboard.then"/> a</td><td class="more-shortcut-descr"><fmt:message key="more.keyboard.about"/></td>
        <td></td><td></td>
    </tr>
</table>

</body></html>
