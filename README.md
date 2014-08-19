sota-cah
========

Shroud of the Avatar: Community Asset Hub - Mura CMS Custom Application

SOTA Community Asset Hub (CAH) is an asset moderation system built, by the community, for Portalarium, Inc.

Portalarium, Inc. was in the process (due 2014) of making the game Shroud of the Avatar under an open development model and utilizing in-game assets created by members of the community. Due to interest in the project and asset submissions of varying skills, a need arose for some sort of filtering process to manage the influx of content. CAH allows for dedicated and personally selected community members to approve or reject content before review by Developers for inclusion in the game. Rejected submissions will get feedback, so users can improve on future assets or refine and resubmit rejected ones. Once multiple Asset Moderators approve an asset it will show up for Developers to review.

This version of CAH is built as a Mura CMS Custom application. It includes custom display objects and a customized theme. No base content is included, but several new class extensions are available for building out a new site.

Basic site structure of functional pages:

- Callouts (Folder / Callouts) Lists requested assets.
- subfolder - Asset Name (Page / Callouts) Created by internal content Renderer function from external spreadsheet.
- Callout Slideshow Images (Folder) Slideshow for Callouts.
- subfolder - Slides (Link / CalloutSide) Create as needed. Category matches Callouts Category for slideshow.
- My Assets (Page / MyAssets) A users submitted assets.
- subfolder - Submit an Asset (Page / MyAssets) Add FormBuilder Form for submission here.
- Submissions (Page / Submissions)

Requirements:
- Railo
- Mura CMS
- MySQL - Custom DB in addition to Mura CMS required
- Unity3D Viewer and Conversion Service (not included)
