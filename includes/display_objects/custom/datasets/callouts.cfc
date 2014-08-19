<cfcomponent>
	<cffunction name="getData" access="public" returntype="any" output="false">

		<cfset feed = application.feedManager.readByName("[ Callouts ]", request.siteid) />
			<cfset feed.setNextN(100) />
			<cfset feed.setMaxItems(100) />
			<cfset iterator=feed.getIterator()>

		<cfset var dataOrder     = ArrayNew() />
		<cfset var dataRecords     = StructNew() />
		<cfset var dataset     = StructNew() />
		
		<cfset dataRecords['default'] = structNew() />
		<cfset dataRecords['default']['datarecordid'] = "default" />
		<cfset dataRecords['default']['label'] = "None" />
		<cfset dataRecords['default']['value'] = "-" />
			<cfset arrayAppend(dataOrder, "default") />


		<cfif iterator.hasNext()>
			<cfloop condition="iterator.hasNext()">
				<cfset item=iterator.next()>

				<cfset idx = item.getValue('CONTENTID') />
				<cfset dataRecords[idx] = structNew() />
				<cfset dataRecords[idx]['datarecordid'] = idx />
				<cfset dataRecords[idx]['label'] = item.getValue('MENUTITLE') />
				<cfset dataRecords[idx]['value'] = item.getValue('REMOTEID') />
					<cfset arrayAppend(dataOrder, idx) />

			</cfloop>
		</cfif>

		<cfset dataset["datarecordorder"] = dataOrder />
		<cfset dataset["datarecords"] = datarecords /> 

		<cfreturn dataset />
	</cffunction>
</cfcomponent>