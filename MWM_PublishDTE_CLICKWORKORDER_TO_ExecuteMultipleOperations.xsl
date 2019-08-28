<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" version="1.0" extension-element-prefixes="dp" exclude-result-prefixes="xsl dp">
	<xsl:output method="xml"/>
	<xsl:template match="/*[local-name()='PublishDTE_CLICKWORKORDER']">
		<!--Start:adding new context for transaction logging-->
		<dp:set-variable name="'var://context/TransLogging/MsgID'" value="dp:generate-uuid()"/>
		<dp:set-variable name="'var://context/TransLogging/CallID'" value="dp:variable('var://context/ServiceLog/CorrelationId')"/>
		<dp:set-variable name="'var://context/TransLogging/CallIDSeq'" value="'1'"/>
		<dp:set-variable name="'var://context/TransLogging/TransType'" value="'ClickRequest'"/>
		<dp:set-variable name="'var://context/TransLogging/MsgType'" value="dp:variable('var://context/ServiceLog/ContextElement5')"/>
		<dp:set-variable name="'var://context/TransLogging/TaskType'" value="dp:variable('var://context/ServiceLog/ContextElement3')"/>
		<dp:set-variable name="'var://context/TransLogging/TaskCategory'" value="/*[local-name()='PublishDTE_CLICKWORKORDER']/*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_SUBST_TASKCATEGORY']/text()"/>
		<dp:set-variable name="'var://context/TransLogging/SchedStart'" value="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SCHEDSTART']/text(),1,19)"/>
		<dp:set-variable name="'var://context/TransLogging/SchedFinish'" value="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SCHEDFINISH']/text(),1,19)"/>
		<dp:set-variable name="'var://context/TransLogging/OrderNo'" value="dp:variable('var://context/ServiceLog/ContextElement1')"/>
		<dp:set-variable name="'var://context/TransLogging/OrderCreateDate'" value="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='REPORTDATE']/text(),1,19)"/>
		<dp:set-variable name="'var://context/TransLogging/Action'" value="'INSERT'"/>
		<dp:set-variable name="'var://context/TransLogging/ProcedureName'" value="'InsertSendHdr'"/>
		<xsl:variable name="OrderType" select="dp:variable('var://context/ServiceLog/ContextElement5')"/>
		<!--End:adding new context for transaction logging-->
		<json:object xsi:schemaLocation="http://www.datapower.com/schemas/json jsonx.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:json="http://www.ibm.com/xmlns/prod/2009/jsonx">
			<json:array name="Operations">
				<xsl:for-each select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SR']">
					<json:object>
						<json:string name="Action">
							<xsl:value-of select="'CreateorUpdate'"/>
						</json:string>
						<json:object name="Object">
							<json:string name="@objectType">
								<xsl:value-of select="'PSServiceRequest'"/>
							</json:string>
							<json:boolean name="@createOrUpdate">
								<xsl:value-of select="'true'"/>
							</json:boolean>
							<json:string name="TicketID">
								<xsl:value-of select="./*[local-name()='TICKETID']/text()"/>
							</json:string>
							<json:string name="SpecialNotes">
								<xsl:value-of select="./*[local-name()='DTE_SOCSR']/*[local-name()='DTE_SPECIALNOTES_LONGDESCRIPTION']/text()"/>
							</json:string>
							<json:string name="SRRemarkDescription">
								<xsl:value-of select="./*[local-name()='REMARKDESC_LONGDESCRIPTION']/text()"/>
							</json:string>
							<json:string name="SRRemark">
								<xsl:value-of select="./*[local-name()='REMARKDESC']/text()"/>
							</json:string>
							<json:string name="SRLongDescription">
								<xsl:value-of select="./*[local-name()='DESCRIPTION_LONGDESCRIPTION']/text()"/>
							</json:string>
							<json:string name="SRDescription">
								<xsl:value-of select="./*[local-name()='DESCRIPTION']/text()"/>
							</json:string>
						</json:object>
					</json:object>
				</xsl:for-each>
				<json:object>
					<json:string name="Action">
						<xsl:value-of select="'CreateorUpdate'"/>
					</json:string>
					<json:object name="Object">
						<json:string name="@objectType">
							<xsl:value-of select="'WorkOrderItem'"/>
						</json:string>
						<json:boolean name="@createOrUpdate">
							<xsl:value-of select="'true'"/>
						</json:boolean>
						<json:string name="WorkOrderItemID">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='WONUM']/text()"/>
						</json:string>
						<json:number name="WorkOrderItemNumber">1</json:number>
						<json:string name="PSParentWODescription">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='PARENT_DESC']/text()"/>
						</json:string>
						<json:string name="PSParentWO">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='PARENT_WONUM']/text()"/>
						</json:string>
						<json:string name="PSDescriptionClass">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='CLASSSTRUCTURE']/*[local-name()='DESCRIPTION_CLASS']/text()"/>
						</json:string>
						<json:string name="PSClassStructureID">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='CLASSSTRUCTURE']/*[local-name()='CLASSSTRUCTUREID']/text()"/>
						</json:string>
						<json:string name="PSUnitCenter">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_UNIT_CENTER']/text()"/>
						</json:string>
						<json:string name="PSPersonGroup">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='PERSONGROUP']/text()"/>
						</json:string>
						<json:string name="PSProjectID">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='FINCNTRL']/*[local-name()='PROJECTID']/text()"/>
						</json:string>
						<json:string name="PSAssetSerialNumber">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='SERIALNUM']/text()"/>
						</json:string>
						<json:string name="PSAssetDescription">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='DESCRIPTION']/text()"/>
						</json:string>
						<json:string name="PSLocationDescription">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DESCRIPTION']/text()"/>
						</json:string>
						<json:string name="Comments">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DESCRIPTION']/text()"/>
						</json:string>
						<json:string name="Description">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DESCRIPTION_LONGDESCRIPTION']/text()"/>
						</json:string>
					</json:object>
				</json:object>
				<json:object>
					<json:string name="Action">
						<xsl:value-of select="'CreateorUpdate'"/>
					</json:string>
					<json:object name="Object">
						<json:string name="@objectType">
							<xsl:value-of select="'Task'"/>
						</json:string>
						<json:boolean name="@createOrUpdate">
							<xsl:value-of select="'true'"/>
						</json:boolean>
						<json:number name="Key">-1</json:number>
						<json:string name="ExternalRefID">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='WONUM']/text()"/>
						</json:string>
						<json:string name="CallID">
							<xsl:value-of select="dp:variable('var://context/ServiceLog/CorrelationId')"/>
						</json:string>
						<json:number name="Number">1</json:number>
						<json:number name="Priority">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='WOPRIORITY']/text()"/>
						</json:number>
						<!--round(yournum*100) div 100-->
						<xsl:choose>
							<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ESTDUR']/text()) &gt; 0">
								<json:number name="Duration">
									<xsl:value-of select="round((./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ESTDUR']/text() * 3600) *100) div 100"/>
								</json:number>
							</xsl:when>
						</xsl:choose>
						<json:object name="TaskTypeCategory">
							<json:string name="Name">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_SUBST_TASKCATEGORY']/text()"/>
							</json:string>
						</json:object>
						<json:object name="TaskType">
							<json:string name="Name">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_SUBST_TASKNAME']/text()"/>
							</json:string>
						</json:object>
						<json:object name="Area">
							<json:string name="Name">
								<xsl:value-of select="'Substations'"/>
							</json:string>
						</json:object>
						<json:object name="Region">
							<json:string name="Name">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_SUBST_REGION']/text()"/>
							</json:string>
						</json:object>
						<json:object name="District">
							<json:string name="Name">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_SUBST_DISTRICT']/text()"/>
							</json:string>
						</json:object>
						<json:string name="PSWorkOrderDesc">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DESCRIPTION']/text()"/>
						</json:string>
						<json:string name="PSWorkOrderLongDesc">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DESCRIPTION_LONGDESCRIPTION']/text()"/>
						</json:string>
						<json:string name="PSWorkLog">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='WORKLOG']/*[local-name()='DESCRIPTION_LONGDESCRIPTION']/text()"/>
						</json:string>
						<xsl:if test="$OrderType='ORDERMODIFY'">
							<xsl:choose>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='STATUS']/text() ='APPR'">
									<json:object name="Status">
										<json:string name="Name">
											<xsl:value-of select="'Ready to Assign'"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='STATUS']/text() ='FDRECV'">
									<json:object name="Status">
										<json:string name="Name">
											<xsl:value-of select="'Ready to Assign'"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='STATUS']/text() ='FDONHOLD'">
									<json:object name="Status">
										<json:string name="Name">
											<xsl:value-of select="'On-Hold'"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='STATUS']/text() ='FDHFND'">
									<json:object name="Status">
										<json:string name="Name">
											<xsl:value-of select="'HFND'"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='STATUS']/text() ='CLKCAN'">
									<json:object name="Status">
										<json:string name="Name">
											<xsl:value-of select="'Cancelled'"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='STATUS']/text() ='CAN-COMP'">
									<json:object name="Status">
										<json:string name="Name">
											<xsl:value-of select="'Cancelled'"/>
										</json:string>
									</json:object>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<json:string name="PSSubstation">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_SUB_CIR']/text()"/>
						</json:string>
						<json:string name="Street">
							<xsl:variable name="StreetName">
								<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTRTPREDIR']/text()) &gt; 0">
									<xsl:value-of select="concat(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTRTPREDIR']/text(), ' ' )"/>
								</xsl:if>
								<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTRTNUM']/text()) &gt; 0">
									<xsl:value-of select="concat(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTRTNUM']/text(), ' ' )"/>
								</xsl:if>
								<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTREET']/text()) &gt; 0">
									<xsl:value-of select="concat(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTREET']/text(), ' ' )"/>
								</xsl:if>
								<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTRTSUFFIX']/text()) &gt; 0">
									<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTRTSUFFIX']/text()"/>
								</xsl:if>
							</xsl:variable>
							<xsl:value-of select="$StreetName"/>
						</json:string>
						<json:string name="City">
							<xsl:variable name="City">
								<xsl:choose>
									<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDCITY']/text()) &gt; 0">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDCITY']/text()"/>
									</xsl:when>
									<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDTOWNSHIP']/text()) &gt; 0">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDTOWNSHIP']/text()"/>
									</xsl:when>
									<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDCOUNTY']/text()) &gt; 0">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDCOUNTY']/text()"/>
									</xsl:when>
									<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDMUNICIPAL']/text()) &gt; 0">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDMUNICIPAL']/text()"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$City"/>
						</json:string>
						<json:string name="State">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDSTATE']/text()"/>
						</json:string>
						<json:string name="Postcode">
							<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='DTE_ADDZIP']/text()"/>
						</json:string>
						<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'LATITUDE' and *[local-name()='ALNVALUE'] != '']">
							<json:number name="Latitude">
								<xsl:value-of select="substring(translate(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'LATITUDE' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE'],'.',''),1,8)"/>
							</json:number>
						</xsl:if>
						<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'LONGITUDE' and *[local-name()='ALNVALUE'] != '']">
							<json:number name="Longitude">
								<xsl:value-of select="substring(translate(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'LONGITUDE' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE'],'.',''),1,9)"/>
							</json:number>
						</xsl:if>
						<json:object name="CountryID">
							<json:string name="Name">
								<xsl:value-of select="'United States'"/>
							</json:string>
						</json:object>
						<json:string name="OpenDate">
							<xsl:value-of select="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='REPORTDATE']/text(),1,19)"/>
						</json:string>
						<json:string name="EarlyStart">
							<xsl:value-of select="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SCHEDSTART']/text(),1,19)"/>
						</json:string>
						<json:string name="DueDate">
							<xsl:value-of select="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SCHEDFINISH']/text(),1,19)"/>
						</json:string>
						<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SR']/*[local-name()='TICKETID']/text()) &gt; 0">
							<json:object name="PSServiceRequest">
								<json:string name="TicketID">
									<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SR']/*[local-name()='TICKETID']/text()"/>
								</json:string>
							</json:object>
						</xsl:if>
						<json:object name="WorkOrderItem">
							<json:string name="WorkOrderItemID">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='WONUM']/text()"/>
							</json:string>
							<json:string name="WorkOrderItemNumber">
								<xsl:value-of select="'1'"/>
							</json:string>
						</json:object>
						<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='CLASSSTRUCTURE']/*[local-name()='CLASSIFICATIONID']/text()) &gt; 0">
							<json:object name="PSClassification">
								<json:string name="Name">
									<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='CLASSSTRUCTURE']/*[local-name()='CLASSIFICATIONID']/text()"/>
								</json:string>
							</json:object>
						</xsl:if>
						<json:object name="TaskSubType">
							<json:string name="Code">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_TASKTYPE']/text()"/>
							</json:string>
							<json:string name="TaskType">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_SUBST_TASKNAME']/text()"/>
							</json:string>
						</json:object>
						<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_RSDNUM']/text()) &gt; 0">
							<json:string name="PSRSDTicketID">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_RSDNUM']/text()"/>
							</json:string>
						</xsl:if>
						<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_RSDNUM']/text()) &gt; 0">
							<json:object name="PSRSDKey">
								<json:string name="TicketID">
									<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='DTE_WORKORDER']/*[local-name()='DTE_RSDNUM']/text()"/>
								</json:string>
							</json:object>
						</xsl:if>
						<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SR']/*[local-name()='TICKETID']/text()) &gt; 0">
							<json:string name="PSSRTicketID">
								<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='SR']/*[local-name()='TICKETID']/text()"/>
							</json:string>
						</xsl:if>
						<json:array name="PSHeader">
							<!-- BreakerRatedVolt to ASSETSPEC.ASSETATTRID=NOMINAL_OPERATING_VOLTAGE.NUMVALUE-->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_VOLTAGE' and *[local-name()='NUMVALUE'] != '']">
								<json:object>
									<json:string name="Name">BreakerRatedVolt</json:string>
									<json:string name="Value">
										<xsl:value-of select="format-number(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_VOLTAGE' and *[local-name()='NUMVALUE'] != '']/*[local-name()='NUMVALUE'], '####.##')"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!--BreakerRatedVoltCurrent1 to ASSETSPEC.ASSETATTRID=NOMINAL_OPERATING_AMP_RATING.NUMVALUE-->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_AMP_RATING' and *[local-name()='NUMVALUE'] != '']">
								<json:object>
									<json:string name="Name">BreakerRatedVoltCurrent1</json:string>
									<json:string name="Value">
										<xsl:value-of select="substring-before(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_AMP_RATING' and *[local-name()='NUMVALUE'] != '']/*[local-name()='NUMVALUE'], '.')"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- BreakerType to ASSETSPEC.ASSETATTRID=BREAKER_TYPE.ALNVALUE-->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'BREAKER_TYPE' and *[local-name()='ALNVALUE'] != '']">
								<json:object>
									<json:string name="Name">BreakerType</json:string>
									<json:string name="Value">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'BREAKER_TYPE' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- CurrentRating to to ASSETSPEC.ASSETATTRID=NOMINAL_OPERATING_AMP_RATING.NUMVALUE-->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_AMP_RATING' and *[local-name()='NUMVALUE'] != '']">
								<json:object>
									<json:string name="Name">CurrentRating</json:string>
									<json:string name="Value">
										<xsl:value-of select="substring-before(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_AMP_RATING' and *[local-name()='NUMVALUE'] != '']/*[local-name()='NUMVALUE'], '.')"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- EquipmentType to ASSETSPEC.ATTTRID=REGULATION_TYPE.ALNVALUE -->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'REGULATION_TYPE' and *[local-name()='ALNVALUE'] != '']">
								<json:object>
									<json:string name="Name">EquipmentType</json:string>
									<json:string name="Value">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'REGULATION_TYPE' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- KVARating to ASSETSPEC.ASETATTTRID=REG_KVA.ALNVALUE-->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'REG_KVA' and *[local-name()='ALNVALUE'] != '']">
								<json:object>
									<json:string name="Name">KVARating</json:string>
									<json:string name="Value">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'REG_KVA' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- ManufactureDate to ASSET.INSTALLDATE or ASSET.INSTALATIONDATE -->
							<xsl:choose>
								<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='INSTALLDATE']/text()) &gt; 0">
									<json:object>
										<json:string name="Name">ManufactureDate</json:string>
										<json:string name="Value">
											<xsl:value-of select="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='INSTALLDATE']/text(),1,19)"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='INSTALATIONDATE']/text()) &gt; 0">
									<json:object>
										<json:string name="Name">ManufactureDate</json:string>
										<json:string name="Value">
											<xsl:value-of select="substring(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='INSTALATIONDATE']/text(),1,19)"/>
										</json:string>
									</json:object>
								</xsl:when>
							</xsl:choose>
							<!-- Manufacturer to ASSET.MANUFACTURER-->
							<xsl:if test="string-length(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='MANUFACTURER']/text()) &gt; 0">
								<json:object>
									<json:string name="Name">Manufacturer</json:string>
									<json:string name="Value">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='MANUFACTURER']/text()"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- ManufacturerType to ASSETSPEC.ASSETATTRID=MODEL.ALNVALUE-->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'MODEL' and *[local-name()='ALNVALUE'] != '']">
								<json:object>
									<json:string name="Name">ManufacturerType</json:string>
									<json:string name="Value">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'MODEL' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
									</json:string>
								</json:object>
							</xsl:if>
							<!-- Position to LOCATIONSPEC.ASSETATTRID=POSITION.ALNVALUE or LOCATIONSPEC.ASSETATTRID=BUS_NUMBER.ALNVALUE or ASSETSPEC.ASSETATTRID=BREAKER_POSITION.ALNVALUE or LOCATIONSPEC.ASSETATTRID= 
TRANS_POSITION.ALNVALUE or SUBSTATION_CAP_BANK_NO.ALNVALUE -->
							<xsl:choose>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'POSITION' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Position</json:string>
										<json:string name="Value">
											<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'POSITION' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'BUS_NUMBER' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Position</json:string>
										<json:string name="Value">
											<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'BUS_NUMBER' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'BREAKER_POSITION' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Position</json:string>
										<json:string name="Value">
											<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'BREAKER_POSITION' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'TRANS_POSITION' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Position</json:string>
										<json:string name="Value">
											<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'TRANS_POSITION' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'SUBSTATION_CAP_BANK_NO' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Position</json:string>
										<json:string name="Value">
											<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'SUBSTATION_CAP_BANK_NO' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE']"/>
										</json:string>
									</json:object>
								</xsl:when>
							</xsl:choose>
							<!-- Voltage ASSETSPEC.ATTTRID= REG_VOLTAGE.ALNVALUE or LOCATIONSPEC.ASSETATTRID=BUS_VOLTAGE.NUMVALUE or NOMINAL_OPERATING_VOLTAGE.NUMVALUE -->
							<xsl:choose>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'BUS_VOLTAGE' and *[local-name()='NUMVALUE'] != '']">
									<json:object>
										<json:string name="Name">Voltage</json:string>
										<json:string name="Value">
											<xsl:value-of select="format-number(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='LOCATIONS']/*[local-name()='LOCATIONSPEC'][*[local-name()='ASSETATTRID']= 'BUS_VOLTAGE' and *[local-name()='NUMVALUE'] != '']/*[local-name()='NUMVALUE'], '####.##')"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'REG_VOLTAGE' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Voltage</json:string>
										<json:string name="Value">
											<xsl:value-of select="format-number(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'REG_VOLTAGE' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE'], '####.##')"/>
										</json:string>
									</json:object>
								</xsl:when>
								<xsl:when test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_VOLTAGE' and *[local-name()='ALNVALUE'] != '']">
									<json:object>
										<json:string name="Name">Voltage</json:string>
										<json:string name="Value">
											<xsl:value-of select="format-number(./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'NOMINAL_OPERATING_VOLTAGE' and *[local-name()='ALNVALUE'] != '']/*[local-name()='ALNVALUE'], '####.##')"/>
										</json:string>
									</json:object>
								</xsl:when>
							</xsl:choose>
							<!-- PositionType to ASSETSPEC.ASSETATTRID=BREAKER_DESIGNATION.ALNVALUE -->
							<xsl:if test="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'BREAKER_DESIGNATION' and *[local-name()='NUMVALUE'] != '']">
								<json:object>
									<json:string name="Name">PositionType</json:string>
									<json:string name="Value">
										<xsl:value-of select="./*[local-name()='DTE_CLICKWORKORDERSet']/*[local-name()='WORKORDER']/*[local-name()='ASSET']/*[local-name()='ASSETSPEC'][*[local-name()='ASSETATTRID']= 'BREAKER_DESIGNATION' and *[local-name()='NUMVALUE'] != '']/*[local-name()='NUMVALUE']"/>
									</json:string>
								</json:object>
							</xsl:if>
						</json:array>
					</json:object>
				</json:object>
			</json:array>
			<json:boolean name="OneTransaction">
				<xsl:value-of select="'true'"/>
			</json:boolean>
			<json:boolean name="ContinueOnError">
				<xsl:value-of select="'false'"/>
			</json:boolean>
		</json:object>
	</xsl:template>
</xsl:stylesheet>
