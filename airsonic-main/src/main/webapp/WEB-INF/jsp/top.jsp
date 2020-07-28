<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <script type="text/javascript" src="<c:url value='/dwr/engine.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/dwr/interface/multiService.js'/>"></script>

    <script type="text/javascript">
        var previousQuery = "";
        var instantSearchTimeout;
        var showSideBar = ${model.showSideBar ? 'true' : 'false'};

        function triggerInstantSearch() {
            if (instantSearchTimeout) {
                window.clearTimeout(instantSearchTimeout);
            }
            instantSearchTimeout = window.setTimeout(executeInstantSearch, 300);
        }

        function executeInstantSearch() {
            var query = $("#query").val().trim();
            if (query.length > 1 && query != previousQuery) {
                previousQuery = query;
                document.searchForm.submit();
            }
        }

        function showLeftFrame() {
            $("#show-left-frame").hide();
            $("#hide-left-frame").show();
            toggleLeftFrame(230);
            multiService.setShowSideBar(true);
            showSideBar = true;
        }

        function hideLeftFrame() {
            $("#hide-left-frame").hide();
            $("#show-left-frame").show();
            toggleLeftFrame(0);
            multiService.setShowSideBar(false);
            showSideBar = false;
        }

        function toggleLeftFrameVisible() {
            if (showSideBar) hideLeftFrame();
            else showLeftFrame();
        }

        function toggleLeftFrame(width) {
            <%-- Disable animation in Chrome. It stopped working in Chrome 44. --%>
            var duration = navigator.userAgent.indexOf("Chrome") != -1 ? 0 : 400;

            $("#dummy-animation-target").stop();
            $("#dummy-animation-target").animate({"max-width": width}, {
                step: function (now, fx) {
                    top.document.getElementById("mainFrameset").cols = now + ",*";
                },
                duration: duration
            });
        }
    </script>
</head>

<body class="topframe">

	<span id="dummy-animation-target" style="max-width:0;display: none"></span>

	<fmt:message key="top.home" var="home"/>
	<fmt:message key="top.now_playing" var="nowPlaying"/>
	<fmt:message key="top.starred" var="starred"/>
	<fmt:message key="left.playlists" var="playlists"/>
	<fmt:message key="top.settings" var="settings"/>
	<fmt:message key="top.status" var="status" />
	<fmt:message key="top.podcast" var="podcast"/>
	<fmt:message key="top.more" var="more"/>
	<fmt:message key="top.help" var="help"/>
	<fmt:message key="top.search" var="search"/>

	<h1 class="logo">Booksonic</h1>
	<nav>
		<ul>
			<li class="navli"><a href="home.view?" target="main">${home}</a></li>
			<li class="navli"><a href="#" onclick="toggleLeftFrameVisible()">Authors</a></li>
			<li class="navli"><a href="nowPlaying.view?" target="main">${nowPlaying}</a></li>
			<li class="navli"><a href="starred.view?" target="main">${starred}</a></li>
			<li class="navli"><a href="playlists.view?" target="main">${playlists}</a></li>
			<li class="navli"><a href="podcastChannels.view?" target="main">${podcast}</a></li>
			<c:if test="${model.user.settingsRole}">
				<li class="navli"><a href="settings.view?" target="main">${settings}</a></li>
			</c:if>
			<li class="navli"><a href="status.view?" target="main">${status}</a></li>
			<li class="navli"><a href="more.view?" target="main">${more}</a></li>
			<li class="navli"><a href="help.view?" target="main">${help}</a></li>
		</ul>
	</nav>
				
	<div style="float: right; margin-top: 10px;">
		<form method="post" action="search.view" target="main" name="searchForm">
			<input required="" type="text" name="query" id="query" size="60" placeholder="Search" onclick="select();" onkeyup="triggerInstantSearch();">
			<a href="javascript:document.searchForm.submit()"><img src="icons/default_dark/search.png" alt="Search" title="Search"></a>
		</form>
    </div>
	
</body></html>
