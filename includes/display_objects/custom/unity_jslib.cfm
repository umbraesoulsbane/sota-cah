<script type="text/javascript">
<!-- 
	var unityObjectUrl = "http://webplayer.unity3d.com/download_webplayer-3.x/3.0/uo/UnityObject2.js";
	if (document.location.protocol == 'https:') unityObjectUrl = unityObjectUrl.replace("http://", "https://ssl-");
	document.write('<script type="text\/javascript" src="' + unityObjectUrl + '"><\/script>');
-->
</script>
<script type="text/javascript">
<!--
	var config = {
		width: 800, 
		height: 400,
		params: { enableDebugging:"1" }
	};
	config.params["disableContextMenu"] = true;

	var u = new UnityObject2(config);

	jQuery(function() {
		var $missingScreen = jQuery("#unityPlayer").find(".missing");
		var $brokenScreen = jQuery("#unityPlayer").find(".broken");
		$missingScreen.hide();
		$brokenScreen.hide();

		u.observeProgress(function (progress) {
			switch(progress.pluginStatus) {
				case "broken":
					$brokenScreen.find("a").click(function (e) {
						e.stopPropagation();
						e.preventDefault();
						u.installPlugin();
						return false;
					});
					$brokenScreen.show();
					break;
				case "missing":
					$missingScreen.find("a").click(function (e) {
						e.stopPropagation();
						e.preventDefault();
						u.installPlugin();
						return false;
					});
					$missingScreen.show();
					break;
				case "installed":
					$missingScreen.remove();
					break;
				case "first":
					break;
				default:
					$("#unityPlayer").html("<p class='err'>Unity Player unsupported on your device.</p>");
			}
		});
		u.initPlugin(jQuery("#unityPlayer")[0], <cfoutput>"#$.siteConfig('assetPath')#/assets/File/sota.unity3d"</cfoutput>);
	});
	-->
</script>

