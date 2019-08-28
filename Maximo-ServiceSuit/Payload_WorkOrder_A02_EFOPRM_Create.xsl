<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:vtx="http://www.ventyx.com/ServiceSuite" xmlns:exsl="http://exslt.org/common" xmlns:dp="http://www.datapower.com/extensions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:dyn="http://exslt.org/dynamic" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:mro="http://www.mro.com/mx/integration" xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="dp regexp dyn date exsl" exclude-result-prefixes="dp dpconfig dyn regexp date exsl mro" version="1.0">
	<xsl:output method="xml"/>
	<xsl:include href="ALM_X_Utilities.xsl"/>
	<xsl:include href="datetime_lib.xsl"/>
	<xsl:param name="dpconfig:TableCache" select="'http://127.0.0.1:50012/TableCache/ServiceSuite'"/>
	<xsl:variable name="TargetStartDate" select="/mro:DTEADVWOIface/mro:Content/mro:DTEADVWO/mro:WORKORDER/mro:TARGSTARTDATE/text()"/>
	<xsl:variable name="TargetCompDate" select="/mro:DTEADVWOIface/mro:Content/mro:DTEADVWO/mro:WORKORDER/mro:TARGCOMPDATE/text()"/>
	<xsl:variable name="CalcPriority" select="/mro:DTEADVWOIface/mro:Content/mro:DTEADVWO/mro:WORKORDER/mro:CALCPRIORITY/text()"/>
	<!-- get system time-->
	<xsl:variable name="tempVAR" select="substring-after(dp:variable('var://service/system/ident')/identification/current-time,' ')"/>
	<!-- get daylight saving offset-->
	<xsl:variable name="vnewzoneOffset">
		<xsl:choose>
			<xsl:when test="$tempVAR='EDT'">
				<xsl:text>-04:00</xsl:text>
			</xsl:when>
			<xsl:when test="$tempVAR='EST'">
				<xsl:text>-05:00</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>+00:00</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rightNow" select="date:date-time()"/>
	<xsl:variable name="NeedDate">
		<xsl:choose>
			<xsl:when test="$TargetCompDate!=''">
				<xsl:value-of select="substring-before($TargetCompDate,'T')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($rightNow,'T')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="StartDate">
		<xsl:choose>
			<xsl:when test="$TargetStartDate!=''">
				<xsl:value-of select="substring-before($TargetStartDate,'T')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($rightNow,'T')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="space" select="'  '"/>
	<xsl:variable name="VTX_NS" select="'http://www.ventyx.com/ServiceSuite'"/>
	<xsl:template match="/mro:DTEADVWOIface/mro:Content/mro:DTEADVWO/mro:WORKORDER">
		<xsl:variable name="WorkOrderID">
			<xsl:value-of select="./mro:WORKORDERID/text()"/>
		</xsl:variable>
		<!-- Build WorkOrder-->
		<WorkOrder xmlns="urn:soi.ventyx.com:payload:V1_3">
			<Action>Created</Action>
			<RecordConfig>ServiceSuite9.2</RecordConfig>
			<!-- Build WorkOrderRecord-->
			<WorkOrderRecord action="Created">
				<OrderNumber>
					<xsl:value-of select="concat('WO',$WorkOrderID)"/>
				</OrderNumber>
				<OrderClass>Field</OrderClass>
				<xsl:variable name="NeedDate">
					<xsl:choose>
						<xsl:when test="string-length($TargetCompDate) &gt; 0">
							<xsl:value-of select="substring-before($TargetCompDate,'T')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before($rightNow,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Build WorkOrderTask-->
				<Tasks>
					<WorkOrderTask>
						<xsl:attribute name="eventAt"><xsl:value-of select="$rightNow"/></xsl:attribute>
						<xsl:attribute name="eventType"/>
						<xsl:attribute name="action"><xsl:value-of select="'Created'"/></xsl:attribute>
						<TaskType>
							<xsl:choose>
								<xsl:when test="string-length($CalcPriority) = 0">
									<xsl:value-of select="'2'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$CalcPriority"/>
								</xsl:otherwise>
							</xsl:choose>
						</TaskType>
						<TaskNumber>
							<xsl:value-of select="concat('WO',$WorkOrderID)"/>
						</TaskNumber>
						<TaskPriority>
							<xsl:value-of select="$CalcPriority"/>
						</TaskPriority>
						<Organization>
							<BusinessUnit>
								<xsl:value-of select="./mro:TMP_CLASSIFID/text()"/>
							</BusinessUnit>
							<DispatchArea>
								<xsl:value-of select="./mro:WORKLOCATION/text()"/>
							</DispatchArea>
						</Organization>
						<TaskAssignment>
							<UserId>
								<xsl:value-of select="translate(./mro:DTE_ASSIGNMENT,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
							</UserId>
						</TaskAssignment>
						<!-- Build Location-->
						<Location>
							<Position>
								<xsl:attribute name="latitude"><xsl:value-of select="./mro:DTE_ADDLAT/text()"/></xsl:attribute>
								<xsl:attribute name="longitude"><xsl:value-of select="./mro:DTE_ADDLON/text()"/></xsl:attribute>
							</Position>
							<Address>
								<xsl:variable name="addressLine1">
									<xsl:call-template name="left-trim">
										<xsl:with-param name="string" select="concat(./mro:DTE_ADDSTRTPREDIR/text(),$space,./mro:DTE_ADDSTREET/text(),$space,./mro:DTE_ADDSTRTSUFFIX/text(),$space,./mro:DTE_ADDSTRTPOSTDIR/text())"/>
									</xsl:call-template>
								</xsl:variable>
								<AddressLine>
									<xsl:value-of select="$addressLine1"/>
								</AddressLine>
								<AddressLine>
									<xsl:call-template name="left-trim">
										<xsl:with-param name="string" select="concat(./mro:DTE_ADDBUILDING/text(),$space,./mro:DTE_ADDFLOOR/text(),$space,./mro:DTE_ADDSECCODE/text(),$space,./mro:DTE_ADDSECNUM/text())"/>
									</xsl:call-template>
								</AddressLine>
								<AddressLine>
									<xsl:value-of select="$addressLine1"/>
								</AddressLine>
								<AddressLine>
									<xsl:value-of select="./mro:DTE_ADDSTRTNUM/text()"/>
								</AddressLine>
								<CityName>
									<xsl:choose>
										<xsl:when test="string-length(./mro:DTE_ADDCITY/text()) &gt; 0">
											<xsl:value-of select="substring(./mro:DTE_ADDCITY/text(),1,20)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(./mro:DTE_ADDTOWNSHIP/text(),1,20)"/>
										</xsl:otherwise>
									</xsl:choose>
								</CityName>
								<CountrySubDivisionCode>
									<xsl:value-of select="./mro:DTE_ADDSTATE/text()"/>
								</CountrySubDivisionCode>
								<PostalCode>
									<xsl:value-of select="./mro:DTE_ADDZIP/text()"/>
								</PostalCode>
							</Address>
							<Area>
								<xsl:value-of select="./mro:DTE_SUBAREA"/>
							</Area>
						</Location>
						<!-- Build TaskTracking-->
						<TaskTracking>
							<Originator>
								<OriginatorId>
									<xsl:value-of select="./mro:REPORTEDBY"/>
								</OriginatorId>
							</Originator>
						</TaskTracking>
						<!-- Build TaskData -->
						<!-- Different from RAV and CAM, do not drop first two characters and ClassStructureID not used for lookup-->
						<xsl:variable name="preProcessSubType" select="./mro:DTE_SUBTYPE"/>
						<xsl:variable name="TABLE_RECORDS">
							<xsl:copy-of select="document(concat($dpconfig:TableCache,'/DTESSMROJOBCODE'))/ListOfRecord/Record[JOBCODE=$preProcessSubType]"/>
						</xsl:variable>
						<xsl:variable name="TABLE_NODE" select="exsl:node-set($TABLE_RECORDS)"/>
						<xsl:variable name="jobCodeSummary" select="$TABLE_NODE/Record/ADVJOBCODE/text()"/>
						<xsl:variable name="jobCodeDescription" select="$TABLE_NODE/Record/ADVJOBCODEDESC/text()"/>
						<xsl:variable name="jobCodeCategory" select="$TABLE_NODE/Record/JOBCODECATEGORY/text()"/>
						<xsl:variable name="resourceCode" select="$TABLE_NODE/Record/ADVJOBCODE/text()"/>
						<!-- Reused variables from WOSpec-->
						<xsl:variable name="meterInstall">
							<xsl:variable name="tempInstallValue">
								<xsl:call-template name="processWorkOrderSpecDefault">
									<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
									<xsl:with-param name="assetAttrIDValue" select="'METER_INSTALL'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="string-length($tempInstallValue) > 0">
									<xsl:value-of select="$tempInstallValue"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="tempRemoveValue">
										<xsl:call-template name="processWorkOrderSpecDefault">
											<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
											<xsl:with-param name="assetAttrIDValue" select="'METER_REMOVE'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:if test="string-length($tempRemoveValue) > 0">
										<xsl:value-of select="$tempRemoveValue"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<TaskData>
							<vtx:OrderRecord>
								<vtx:StdHostJobNmbr>
									<xsl:value-of select="concat('WO',./mro:WONUM/text())"/>
								</vtx:StdHostJobNmbr>
								<vtx:NeedDate>
									<xsl:value-of select="$NeedDate"/>
								</vtx:NeedDate>
								<vtx:StdCity>
									<xsl:choose>
										<xsl:when test="string-length(./mro:DTE_ADDCITY/text()) &gt; 0">
											<xsl:value-of select="substring(./mro:DTE_ADDCITY/text(),1,45)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(./mro:DTE_ADDTOWNSHIP/text(),1,45)"/>
										</xsl:otherwise>
									</xsl:choose>
								</vtx:StdCity>
								<xsl:variable name="rateRevClassCode">
									<xsl:variable name="installProdCodeCSB">
										<xsl:call-template name="processWorkOrderSpecDefault">
											<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
											<xsl:with-param name="assetAttrIDValue" select="'CSB_INSTALL_PROD_CODE'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="string-length($installProdCodeCSB) &gt; 0">
											<xsl:value-of select="$installProdCodeCSB"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="processWorkOrderSpecDefault">
												<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
												<xsl:with-param name="assetAttrIDValue" select="'KCS_INSTALL_PROD_CODE'"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<vtx:RateRevClassCd>
									<xsl:value-of select="$rateRevClassCode"/>
								</vtx:RateRevClassCd>
								<xsl:choose>
									<xsl:when test="$meterInstall='INSTALL'">
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'METER_LOCATION_INSTALL'"/>
											<xsl:with-param name="TAG_NAME" select="'MeterLocCode'"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="$meterInstall='REMOVE'">
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'LOCATION_REMOVE'"/>
											<xsl:with-param name="TAG_NAME" select="'MeterLocCode'"/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
								<vtx:JobCodeDescription>
									<xsl:value-of select="$jobCodeDescription"/>
								</vtx:JobCodeDescription>
								<xsl:choose>
									<xsl:when test="$meterInstall='INSTALL'">
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'METER_NUMBER_INSTALL'"/>
											<xsl:with-param name="TAG_NAME" select="'StdMtrNo'"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="$meterInstall='REMOVE'">
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'METER_NUMBER_REMOVE'"/>
											<xsl:with-param name="TAG_NAME" select="'StdMtrNo'"/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
								<vtx:StdCustName>
									<xsl:value-of select="./mro:DTE_CUSTNAME/text()"/>
								</vtx:StdCustName>
								<vtx:JobCodeSummary>
									<xsl:value-of select="$jobCodeSummary"/>
								</vtx:JobCodeSummary>
								<vtx:StreetNumber>
									<xsl:value-of select="./mro:DTE_ADDSTRTNUM"/>
								</vtx:StreetNumber>
								<vtx:StdZipCode>
									<xsl:value-of select="./mro:DTE_ADDZIP"/>
								</vtx:StdZipCode>
								<vtx:InstallationNumber>
									<xsl:value-of select="./mro:LOCATION/text()"/>
								</vtx:InstallationNumber>
								<xsl:variable name="DteSpecialRequirements">
									<xsl:variable name="longDescription">
										<xsl:value-of select="translate($DteLongDescription, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
									</xsl:variable>
									<xsl:variable name="crewMeet">
										<xsl:call-template name="processWorkOrderSpecDefault">
											<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
											<xsl:with-param name="assetAttrIDValue" select="'CREW_MEET'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="radioFreq">
										<xsl:call-template name="processWorkOrderSpecDefault">
											<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
											<xsl:with-param name="assetAttrIDValue" select="'RADIO_FREQ'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:if test="string-length($crewMeet) &gt; 0">
										<xsl:value-of select="$crewMeet"/>
									</xsl:if>
									<xsl:if test="$radioFreq = 'Y'">
										<xsl:value-of select="' - RF     meter required'"/>
									</xsl:if>
									<xsl:if test="contains($longDescription,'ADVANTEX NOTES IN WORKLOG')">
										<xsl:value-of select="'NT'"/>
									</xsl:if>
								</xsl:variable>
								<vtx:DteSpecialRequirements>
									<xsl:value-of select="$DteSpecialRequirements"/>
								</vtx:DteSpecialRequirements>
								<vtx:UnitCenter>
									<xsl:value-of select="./mro:DTE_UNIT_CENTER/text()"/>
								</vtx:UnitCenter>
								<vtx:AMIStatus>
									<xsl:value-of select="./mro:DTE_AMISTATUS/text()"/>
								</vtx:AMIStatus>
								<xsl:variable name="CS11">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTRTDIM/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTRTDIM/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS12">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTRTDIR/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTRTDIR/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS13">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTRTPRE/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTRTPRE/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS14">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTREET/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTREET/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS15">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTRTSFX/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTRTSFX/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS16">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTRTPOST/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTRTPOST/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS1" select="concat($CS11,$CS12,$CS13,$CS14,$CS15,$CS16)"/>
								<xsl:variable name="CrossStreets1Var_trim">
									<xsl:call-template name="left-trim">
										<xsl:with-param name="string" select="concat(./mro:DTE_FIRSTSTRTDIM/text(),$space,./mro:DTE_FIRSTSTRTDIR/text(),$space,./mro:DTE_FIRSTSTRTPRE/text(),$space,./mro:DTE_FIRSTSTREET/text(),$space,./mro:DTE_FIRSTSTRTSFX/text(),$space,./mro:DTE_FIRSTSTRTPOST/text())"/>
									</xsl:call-template>
								</xsl:variable>
								<vtx:CrossStreets1>
									<xsl:value-of select="$CrossStreets1Var_trim"/>
								</vtx:CrossStreets1>
								<xsl:variable name="RVStreetDirection2">
									<xsl:call-template name="processLocationSpecDefault">
										<xsl:with-param name="LOCATIONSPEC_PARENT_NODE" select="./mro:LOCATIONS"/>
										<xsl:with-param name="assetAttrIDValue" select="'RVSTREETDIRECTION2'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="CS21">
									<xsl:if test="string-length(./mro:DTE_FIRSTSTRTDIM/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_FIRSTSTRTDIM/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS22">
									<xsl:if test="string-length(./mro:DTE_SECNDSTRTDIR/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_SECNDSTRTDIR/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS23">
									<xsl:if test="string-length(./mro:DTE_SECNDSTRTPRE/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_SECNDSTRTPRE/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS24">
									<xsl:if test="string-length(./mro:DTE_SECNDSTREET/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_SECNDSTREET/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS25">
									<xsl:if test="string-length(./mro:DTE_SECNDSTRTSFX/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_SECNDSTRTSFX/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS26">
									<xsl:if test="string-length(./mro:DTE_SECNDSTRTPOST/text()) &gt; 0">
										<xsl:value-of select="concat(./mro:DTE_SECNDSTRTPOST/text(),$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS27">
									<xsl:if test="string-length($RVStreetDirection2) &gt; 0">
										<xsl:value-of select="concat(RVStreetDirection2,$space)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="CS2" select="concat($CS21,$CS22,$CS23,$CS24,$CS25,$CS26,$CS27)"/>
								<xsl:variable name="CrossStreets2Var_trim">
									<xsl:call-template name="left-trim">
										<xsl:with-param name="string" select="concat(./mro:DTE_SECNDSTRTDIM/text(),$space,./mro:DTE_SECNDSTRTDIR/text(),$space,./mro:DTE_SECNDSTRTPRE/text(),$space,./mro:DTE_SECNDSTREET/text(),$space,./mro:DTE_SECNDSTRTSFX/text(),$space,./mro:DTE_SECNDSTRTPOST/text())"/>
									</xsl:call-template>
								</xsl:variable>
								<vtx:CrossStreets2>
									<xsl:value-of select="$CrossStreets2Var_trim"/>
								</vtx:CrossStreets2>
								<vtx:StdState>
									<xsl:value-of select="./mro:DTE_ADDSTATE"/>
								</vtx:StdState>
							</vtx:OrderRecord>
						</TaskData>
						<!-- Build Schedule/Aggregation-->
						<Schedule isAutoDispatchable="false">
							<Appointment>
								<PlannedEarliestStartAt>
									<xsl:value-of select="concat($StartDate,'T00:00:00',$vnewzoneOffset)"/>
								</PlannedEarliestStartAt>
								<PlannedLatestStartAt>
									<xsl:variable name="futureDate">
										<xsl:call-template name="date-add">
											<xsl:with-param name="date" select="translate(substring-before($rightNow,'T'),'-','')"/>
											<xsl:with-param name="add" select="number(180)"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="concat($futureDate,'T23:59:59',$vnewzoneOffset)"/>
								</PlannedLatestStartAt>
							</Appointment>
							<SchedulingParameters>
								<AggregationId/>
							</SchedulingParameters>
						</Schedule>
						<!-- Build CustomerContact-->
						<CustomerContact>
							<ContactPhone>
								<xsl:value-of select="./mro:DTE_CONTPHONEPRIM/text()"/>
							</ContactPhone>
							<CallAheadMessageNumber>1</CallAheadMessageNumber>
						</CustomerContact>
						<!-- Build Activities-->
						<Activities>
							<xsl:attribute name="multiActivityType">1</xsl:attribute>
							<Activity>
								<xsl:attribute name="action">Created</xsl:attribute>
								<xsl:attribute name="sequence">0</xsl:attribute>
								<ActivityNumber>WO<xsl:value-of select="./mro:WORKORDERID"/>-1</ActivityNumber>
								<ActivityType>A02_EFOPRM</ActivityType>
								<ActivityDuration xsi:nil="true"/>
								<ResourceRequirements>
									<ResourceCode>
										<xsl:value-of select="$resourceCode"/>
									</ResourceCode>
								</ResourceRequirements>
								<ActivityData>
									<vtx:A02_EFOPRM>
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'METER_LOCATION_INSTALL'"/>
											<xsl:with-param name="TAG_NAME" select="'MeterLocCodeNcl'"/>
										</xsl:call-template>
										<xsl:variable name="kWattMeterConst">
											<xsl:choose>
												<xsl:when test="$meterInstall = 'INSTALL'">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_CONSTANT_INSTALL'"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="$meterInstall = 'REMOVE'">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_CONSTANT_REMOVE'"/>
													</xsl:call-template>
												</xsl:when>
											</xsl:choose>
										</xsl:variable>
										<vtx:KwattMtrConst>
											<xsl:value-of select="$kWattMeterConst"/>
										</vtx:KwattMtrConst>
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'DTE_MTR_DEMAND'"/>
											<xsl:with-param name="TAG_NAME" select="'DemandMtrNbr'"/>
										</xsl:call-template>
										<xsl:choose>
											<xsl:when test="$meterInstall = 'INSTALL'">
												<xsl:variable name="meterClassInstall">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_CLASS_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterVoltageInstall">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_VOLTAGE_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterPhaseInstall">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_PHASE_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterNumOfWiresInstall">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_NO_OF_WIRES_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterConfigInstall">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_CONFIG_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterBaseInstall">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_BASE_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<vtx:MtrType>
													<xsl:if test="string-length($meterClassInstall) &gt; 0">
														<xsl:value-of select="concat('CL',$meterClassInstall)"/>
													</xsl:if>
													<xsl:if test="string-length($meterVoltageInstall) &gt; 0">
														<xsl:value-of select="concat(' ',$meterVoltageInstall,'V')"/>
													</xsl:if>
													<xsl:if test="string-length($meterPhaseInstall) &gt; 0">
														<xsl:value-of select="concat(' ',$meterPhaseInstall,'@')"/>
													</xsl:if>
													<xsl:if test="string-length($meterNumOfWiresInstall) &gt; 0">
														<xsl:value-of select="concat(' ',$meterNumOfWiresInstall)"/>
													</xsl:if>
													<xsl:if test="string-length($meterConfigInstall) &gt; 0">
														<xsl:value-of select="concat(' ',$meterConfigInstall)"/>
													</xsl:if>
													<xsl:if test="string-length($meterBaseInstall) &gt; 0">
														<xsl:value-of select="concat(' ',$meterBaseInstall)"/>
													</xsl:if>
												</vtx:MtrType>
											</xsl:when>
											<xsl:when test="$meterInstall = 'REMOVE'">
												<xsl:variable name="meterClass">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_CLASS_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterVoltage">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_VOLTAGE_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterPhase">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_PHASE_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterNumOfWires">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_NO_OF_WIRES_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterConfig">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_CONFIG_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterBase">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_BASE_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<vtx:MtrType>
													<xsl:if test="string-length($meterClass) &gt; 0">
														<xsl:value-of select="concat('CL',$meterClass)"/>
													</xsl:if>
													<xsl:if test="string-length($meterVoltage) &gt; 0">
														<xsl:value-of select="concat(' ',$meterVoltage,'V')"/>
													</xsl:if>
													<xsl:if test="string-length($meterPhase) &gt; 0">
														<xsl:value-of select="concat(' ',$meterPhase,'@')"/>
													</xsl:if>
													<xsl:if test="string-length($meterNumOfWires) &gt; 0">
														<xsl:value-of select="concat(' ',$meterNumOfWires)"/>
													</xsl:if>
													<xsl:if test="string-length($meterConfig) &gt; 0">
														<xsl:value-of select="concat(' ',$meterConfig)"/>
													</xsl:if>
													<xsl:if test="string-length($meterBase) &gt; 0">
														<xsl:value-of select="concat(' ',$meterBase)"/>
													</xsl:if>
												</vtx:MtrType>
											</xsl:when>
										</xsl:choose>
										<vtx:SecondPhoneNo>
											<xsl:value-of select="./mro:DTE_CUSTPHONEPRIM/text()"/>
										</vtx:SecondPhoneNo>
										<vtx:DetailRemarks>
											<xsl:value-of select="./mro:DESCRIPTION_LONGDESCRIPTION/text()"/>
										</vtx:DetailRemarks>
										<xsl:choose>
											<xsl:when test="$meterInstall='INSTALL'">
												<xsl:call-template name="processWorkOrder_WorkOrderSpec">
													<xsl:with-param name="assetAttrIDValue" select="'METER_DIALS_INSTALL'"/>
													<xsl:with-param name="TAG_NAME" select="'MeterNumDials1'"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$meterInstall='REMOVE'">
												<xsl:call-template name="processWorkOrder_WorkOrderSpec">
													<xsl:with-param name="assetAttrIDValue" select="'METER_DIALS_REMOVE'"/>
													<xsl:with-param name="TAG_NAME" select="'MeterNumDials1'"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
										<!-- variable for MaxMtrInfo-->
										<xsl:variable name="ladderRequired">
											<xsl:call-template name="processWorkOrderSpecDefault">
												<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
												<xsl:with-param name="assetAttrIDValue" select="'LADDER_REQ'"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$meterInstall = 'INSTALL'">
												<xsl:variable name="wireLength">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'CT_1_WIRE_LENGTH_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterDemand">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_DEMAND_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterBusBars">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_BUS_BARS_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterFlashTag">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_FLASH/TAG_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterFsBoard">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_FS_BOARD_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="meterHubPlug">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'METER_HUBPLUG_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="ctRatio">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'CT_RATIO_INSTALL'"/>
													</xsl:call-template>
												</xsl:variable>
												<vtx:MaxMtrInfo>
													<xsl:if test="string-length($ladderRequired) &gt; 0">
														<xsl:value-of select="concat('LN= ',$ladderRequired,',')"/>
													</xsl:if>
													<xsl:if test="string-length($wireLength) &gt; 0">
														<xsl:value-of select="concat('WL= ',$wireLength,',')"/>
													</xsl:if>
													<xsl:if test="string-length($meterDemand) &gt; 0">
														<xsl:value-of select="concat('DEM=  ',$meterDemand,',')"/>
													</xsl:if>
													<xsl:if test="string-length($meterBusBars) &gt; 0">
														<xsl:value-of select="concat('BB= ',$meterBusBars,',')"/>
													</xsl:if>
													<xsl:if test="string-length($meterFlashTag) &gt; 0">
														<xsl:value-of select="concat('FT= ',$meterFlashTag,',')"/>
													</xsl:if>
													<xsl:if test="string-length($meterFsBoard) &gt; 0">
														<xsl:value-of select="concat('FB= ',$meterFsBoard,',')"/>
													</xsl:if>
													<xsl:if test="string-length($meterHubPlug) &gt; 0">
														<xsl:value-of select="concat('HP= ',$meterHubPlug,',')"/>
													</xsl:if>
													<xsl:if test="string-length($ctRatio) &gt; 0">
														<xsl:value-of select="concat('CT= ',$ctRatio)"/>
													</xsl:if>
												</vtx:MaxMtrInfo>
											</xsl:when>
											<xsl:when test="$meterInstall = 'REMOVE'">
												<xsl:variable name="ctRatioRemove">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'CT_RATIO_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="demandRemove">
													<xsl:call-template name="processWorkOrderSpecDefault">
														<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="."/>
														<xsl:with-param name="assetAttrIDValue" select="'DEMAND_REMOVE'"/>
													</xsl:call-template>
												</xsl:variable>
												<vtx:MaxMtrInfo>
													<xsl:if test="string-length($ladderRequired) &gt; 0">
														<xsl:value-of select="concat('LN= ',$ladderRequired,',')"/>
													</xsl:if>
													<xsl:if test="string-length($ctRatioRemove) &gt; 0">
														<xsl:value-of select="concat('CT= ',$ctRatioRemove,',')"/>
													</xsl:if>
													<xsl:if test="string-length($demandRemove) &gt; 0">
														<xsl:value-of select="$demandRemove"/>
													</xsl:if>
												</vtx:MaxMtrInfo>
											</xsl:when>
										</xsl:choose>
										<xsl:if test="string-length($maxMtrInfo) &gt; 0">
											<vtx:MaxMtrInfo>
												<xsl:value-of select="$maxMtrInfo"/>
											</vtx:MaxMtrInfo>
										</xsl:if>
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'DETAMITYPE'"/>
											<xsl:with-param name="TAG_NAME" select="'AMIType'"/>
										</xsl:call-template>
										<vtx:StdCreatorId>
											<xsl:value-of select="./mro:REPORTEDBY"/>
										</vtx:StdCreatorId>
										<xsl:variable name="reportDate" select="./mro:REPORTDATE/text()"/>
										<vtx:StdCreateDate>
											<xsl:value-of select="date:month-in-year($reportDate)"/>/<xsl:value-of select="date:day-in-month($reportDate)"/>/<xsl:value-of select="date:year($reportDate)"/>
										</vtx:StdCreateDate>
										<vtx:StdCreateTime>
											<xsl:value-of select="date:hour-in-day($reportDate)"/>:<xsl:value-of select="date:minute-in-hour($reportDate)"/>:<xsl:value-of select="date:second-in-minute($reportDate)"/>
										</vtx:StdCreateTime>
										<xsl:call-template name="processWorkOrder_WorkOrderSpec">
											<xsl:with-param name="assetAttrIDValue" select="'DETTMS'"/>
											<xsl:with-param name="TAG_NAME" select="'MeterTmsCode1'"/>
										</xsl:call-template>
									</vtx:A02_EFOPRM>
								</ActivityData>
							</Activity>
						</Activities>
					</WorkOrderTask>
				</Tasks>
			</WorkOrderRecord>
		</WorkOrder>
	</xsl:template>
	<xsl:template match="*|@*|text()">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template name="processWorkOrder_WorkOrderSpec">
		<xsl:param name="assetAttrIDValue" select="''"/>
		<xsl:param name="TAG_NAME" select="$assetAttrIDValue"/>
		<xsl:element name="{$TAG_NAME}" namespace="{$VTX_NS}">
			<xsl:call-template name="processWorkOrderSpecDefault">
				<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="/mro:DTEADVWOIface/mro:Content/mro:DTEADVWO/mro:WORKORDER"/>
				<xsl:with-param name="assetAttrIDValue" select="$assetAttrIDValue"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="processConcatWorkOrder_WorkOrderSpec">
		<xsl:param name="elementList" select="''"/>
		<xsl:param name="delimiter" select="','"/>
		<xsl:param name="spacer" select="' '"/>
		<xsl:param name="TAG_NAME" select="'NOTAG'"/>
		<xsl:element name="{$TAG_NAME}" namespace="{$VTX_NS}">
			<xsl:call-template name="processWorkOrderSpecConcat">
				<xsl:with-param name="WORKORDERSPEC_PARENT_NODE" select="/mro:DTEADVWOIface/mro:Content/mro:DTEADVWO/mro:WORKORDER"/>
				<xsl:with-param name="elementList" select="$elementList"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
				<xsl:with-param name="spacer" select="$spacer"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
