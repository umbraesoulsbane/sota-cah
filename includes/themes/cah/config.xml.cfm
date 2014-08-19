<!---
	To add mobile-specific content fields to your Edit Content screen:
	1) Uncomment the extensions node below
	2) Reload Application
	3) That's it!
--->
<theme>
	<extensions>
		<extension type="Link" subType="CalloutSlide">
			<attributeset name="Callout References" container="Basic">
				<attribute
					name="remoteCatSlide"
					label="Category"
					hint=""
					type="SelectBox"
					defaultValue="None"
					required="No"
					validation=""
					regex=""
					message=""
					optionList="[mura]$.getRemoteCatOptions()[/mura]"
					optionLabelList="[mura]$.getRemoteCatOptions()[/mura]" />
			</attributeset>
		</extension>


		<extension type="Folder" subType="Issues"></extension>

		<extension type="Folder" subType="Callouts"></extension>
		<extension type="Page" subType="Callouts">
			<attributeset name="Request Details" container="Basic">
				<attribute
					name="bounty"
					label="Bounty"
					hint="The bounty for this Asset Request."
					type="text"
					defaultValue=""
					required="false"
					validation=""
					regex=""
					message=""
				/>
				<attribute
					name="priority"
					label="Priority"
					hint="Priority of Asset Request."
					type="selectbox"
					defaultValue="false"
					required="false"
					validation=""
					regex=""
					message=""
					optionList="Low^Medium^High"
					optionLabelList="Low^Medium^High" />
				 <attribute
					name="assettype"
					label="Type"
					hint="Type of Asset."
					type="text"
					defaultValue=""
					required="false"
					validation=""
					regex=""
					message=""
				 />
				<attribute
					name="remotecat"
					label="Remote Category"
					hint="Category of Asset in Port System."
					type="text"
					defaultValue=""
					required="false"
					validation=""
					regex=""
					message=""
				 />
			</attributeset>	
		</extension>

		<extension type="Page" subType="MyAssets">
			<attributeset name="Asset Listings" container="Basic">
				<attribute
					name="hideList"
					label="Hide Listing"
					hint="Determine whether to show Assets on page."
					type="selectbox"
					defaultValue="false"
					required="false"
					validation=""
					regex=""
					message=""
					optionList="true^false"
					optionLabelList="Yes^No" />
			</attributeset>		
		</extension>

		<extension type="Page" subType="Submissions"></extension>

	</extensions>
</theme>