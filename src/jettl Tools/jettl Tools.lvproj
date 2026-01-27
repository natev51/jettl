<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="25008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">25.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="_Template.lvlib" Type="Library" URL="../_Template/_Template.lvlib"/>
		<Item Name="Template.vi" Type="VI" URL="../Template.vi"/>
		<Item Name="_Rename.lvlib" Type="Library" URL="../_Rename/_Rename.lvlib"/>
		<Item Name="Rename.vi" Type="VI" URL="../Rename.vi"/>
		<Item Name="_Rescript.lvlib" Type="Library" URL="../_Rescript/_Rescript.lvlib"/>
		<Item Name="Rescript.vi" Type="VI" URL="../Rescript.vi"/>
		<Item Name="_Shared.lvlib" Type="Library" URL="../_Shared/_Shared.lvlib"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
