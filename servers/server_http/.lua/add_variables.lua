local ua = require("opcua.api")
local s = ua.StatusCode

local Boolean = "i=1"
local SByte = "i=2"
local Byte = "i=3"
local Int16 = "i=4"
local UInt16 = "i=5"
local Int32 = "i=6"
local UInt32 = "i=7"
local Int64 = "i=8"
local UInt64 = "i=9"
local Float = "i=10"
local Double = "i=11"
local String = "i=12"
local DateTime = "i=13"
local Guid = "i=14"
local ByteString = "i=15"
local XmlElement = "i=16"
local NodeId = "i=17"
local ExpandedNodeId = "i=18"
local StatusCode = "i=19"
local QualifiedName = "i=20"
local LocalizedText = "i=21"
local DataValue = "i=23"
local DiagnosticInfo = "i=25"
local Organizes = "i=35"
local BaseDataVariableType = "i=63"
local ObjectsFolder = "i=85"
local FolderType = "i=61"

local traceI = ua.trace.inf

local function addNodes(services, newVariable)
  local results = services:addNodes(newVariable)
  for i,res in ipairs(results) do
    if res.statusCode == ua.StatusCode.BadNodeIdExists then
      traceI(string.format("   Node '%s' with id '%s' already exists", newVariable.nodesToAdd[i].browseName.name, newVariable.nodesToAdd[i].requestedNewNodeId))
    elseif res.statusCode ~= ua.StatusCode.Good then
      traceE(string.format("Failed to add node '%s': 0x%X", newVariable.nodesToAdd[i].browseName.name, res.statusCode))
      error(resp.statusCode)
    else
      traceI(string.format("   AddedNodeId: %s", res.addedNodeId))
    end
  end
end

local startNodeId = 100000
local function nextId()
  startNodeId = startNodeId + 1
  return "i="..startNodeId
end


local function addBoolean(services, parentNodeId)
  if services.config.logging.services.infOn then
    traceI("Adding Boolean variable")
  end

  -- Array with node id attributes of a new boolean variable
  local value = {
    Type = ua.Types.VariantType.Boolean,
    Value = true
  }
  local newVariable =
  {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "boolean_variable", value, nextId())
    }
  }

  addNodes(services, newVariable)
end

local function addBooleanArray(services, parentNodeId)
  traceI("Adding Boolean Array variable")

  -- Array with node id attributes of a new boolean variable
  local value = {
    Type = ua.Types.VariantType.Boolean,
    IsArray = true,
    Value = {true,false,true,false,true,false,true,false,true,false}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "BooleanArray", value, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addByte(services, parentNodeId)
  traceI("Adding Byte variable")

  -- Array with node id attributes of a new boolean variable
  local byteValue = {
    Type = ua.Types.VariantType.Byte,
    Value = 17
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "Byte", byteValue, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addByteArray(services, parentNodeId)
  traceI("Adding Byte Array variable")

  local byteValue = {
    Type = ua.Types.VariantType.Byte,
    IsArray = true,
    Value = {1,2,3,4,5,6,7,8,9,10}
  }
  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "ByteArray", byteValue, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addSByte(services, parentNodeId)
  traceI("Adding SByte variable")

  -- Array with node id attributes of a new boolean variable
  local sbyteValue = {
    Type = ua.Types.VariantType.SByte,
    Value = -100
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "SByte", sbyteValue, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addSByteArray(services, parentNodeId)
  traceI("Adding SByte Array variable")

  -- Array with node id attributes of a new boolean variable
  local sbyteValue = {
    Type = ua.Types.VariantType.SByte,
    IsArray = true,
    Value = {-2,-1,0,1,2,3,4,5,6,7}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "SByteArray", sbyteValue, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addInt16(services, parentNodeId)
  traceI("Adding Int16 variable")

  -- Array with node id attributes of a new boolean variable
  local int16Value = {
    Type = ua.Types.VariantType.Int16,
    Value = 30000
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "Int16", int16Value, nextId())
    }
  }

  addNodes(services, newVariable)
end

local function addInt16Array(services, parentNodeId)
  traceI("Adding Int16 Array variable")

  -- Array with node id attributes of a new boolean variable
  local int16Array = {
    Type = ua.Types.VariantType.Int16,
    IsArray = true,
    Value = {-2000,-1000,0,100,200,300,400,5000,6000,7000}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "Int16Array", int16Array, nextId())
    }
  }

  addNodes(services, newVariable)
end



local function addUInt16_Scalar_And_Array(services, parentNodeId)
  traceI("Adding UInt16 variable and UInt16 array")

  -- Array with node id attributes of a new boolean variable
  local uint16Value = {
    Type = ua.Types.VariantType.UInt16,
    Value = 30000
  }
  local uint16Array = {
    Type = ua.Types.VariantType.UInt16,
    IsArray = true,
    Value = {2000,1000,0,100,200,300,400,5000,6000,40000}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "UInt16", uint16Value, nextId()),
      ua.newVariableParams(parentNodeId, "UInt16Array", uint16Array, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addInt32_UInt32_Scalar_And_Array(services, parentNodeId)
  traceI("Adding Int32,UInt32 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local uint32Value = {
    Type = ua.Types.VariantType.UInt32,
    Value = 30000
  }
  local uint32Array = {
    Type = ua.Types.VariantType.UInt32,
    IsArray = true,
    Value = {2000,1000,0,100,200,300,4000000,5000,6000,40000}
  }
  local int32Value = {
    Type = ua.Types.VariantType.Int32,
    Value = 1000000
  }
  local int32Array = {
    Type = ua.Types.VariantType.Int32,
    IsArray = true,
    Value = {-2000,1000,0,100,-200,300,-10000,5000,6000,40000}
  }

  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "UInt32", uint32Value, nextId()),
      ua.newVariableParams(parentNodeId, "UInt32Array", uint32Array, nextId()),
      ua.newVariableParams(parentNodeId, "Int32", int32Value, nextId()),
      ua.newVariableParams(parentNodeId, "Int32Array", int32Array, nextId())
    }
  }

  addNodes(services, newVariable)
end



local function addInt64_UInt64_Scalar_And_Array(services, parentNodeId)
  traceI("Adding Int64,UInt64 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local uint64Array = {
    Type = ua.Types.VariantType.UInt64,
    IsArray = true,
    Value = {2000,1000,0,100,200,300,4000000000,5000,6000,40000}
  }
  local int64Value = {
    Type = ua.Types.VariantType.Int64,
    Value = 1000000000
  }
  local int64Array = {
    Type = ua.Types.VariantType.Int64,
    IsArray = true,
    Value = {-2000,1000,0,100,-200,300,-10000000000,5000,6000,40000}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "UInt64Array", uint64Array, nextId()),
      ua.newVariableParams(parentNodeId, "Int64", int64Value, nextId()),
      ua.newVariableParams(parentNodeId, "Int64Array", int64Array, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addFloat_Double_Scalar_And_Array(services, parentNodeId)
  traceI("Adding Float,Double scalar and array")

  -- Array with node id attributes of a new boolean variable
  local floatValue = {
    Type = ua.Types.VariantType.Float,
    Value = 1.1
  }
  local floatArray = {
    Type = ua.Types.VariantType.Float,
    IsArray = true,
    Value = {2.2,3.3}
  }
  local doubleValue = {
    Type = ua.Types.VariantType.Double,
    Value = -1.1
  }
  local doubleArray = {
    Type = ua.Types.VariantType.Double,
    IsArray = true,
    Value = {6000.222,40000.22}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "Float", floatValue, nextId()),
      ua.newVariableParams(parentNodeId, "FloatArray", floatArray, nextId()),
      ua.newVariableParams(parentNodeId, "Double", doubleValue, nextId()),
      ua.newVariableParams(parentNodeId, "DoubleArray", doubleArray, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addString_Scalar_And_Array(services, parentNodeId)
  traceI("Adding String scalar and array")

  -- Array with node id attributes of a new boolean variable
  local stringScalar = {
    Type = ua.Types.VariantType.String,
    Value = "This is a string variable"
  }
  local stringArray = {
    Type = ua.Types.VariantType.String,
    IsArray = true,
    Value = {"Element1", "Element2", "Element3", "Element4", "Element5", "Element6", "Element7", "Element8", "Element9", "Element10"}
  }
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "String", stringScalar, nextId()),
      ua.newVariableParams(parentNodeId, "StringArray", stringArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end

local function addGuid_Scalar_And_Array(services, parentNodeId)
  traceI("Adding Guid scalar and array")

  local guidScalar = {
    Type = ua.Types.VariantType.Guid,
    Value = ua.createGuid()
  }
  local guidArray = {
    Type = ua.Types.VariantType.Guid,
    IsArray = true,
    Value = {ua.createGuid(),ua.createGuid(),ua.createGuid()}
  }
  -- Array with node id attributes of a new variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "Guid", guidScalar, nextId()),
      ua.newVariableParams(parentNodeId, "GuidArray", guidArray, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addDateTime_Scalar_And_Array(services, parentNodeId)
  traceI("Adding DateTime scalar and array")

  local curTime = os.time()
  local dateTimeScalar = {
    Type = ua.Types.VariantType.DateTime,
    Value = curTime + 0.123
  }
  local dateTimeArray ={
    Type = ua.Types.VariantType.DateTime,
    IsArray = true,
    Value = {curTime, curTime - 1, curTime - 2, curTime - 3, curTime - 4, curTime - 5, curTime - 6, curTime - 7, curTime - 8, curTime - 9}
  }
  -- Array with node id attributes of a new variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "DateTime", dateTimeScalar, nextId()),
      ua.newVariableParams(parentNodeId, "DateTimeArray", dateTimeArray, nextId())
    }
  }

  addNodes(services, newVariable)
end

local function addByteString_Scalar_And_Array(services, parentNodeId)
  traceI("Adding ByteString scalar and array")

  local byteStringScalar = {
    Type = ua.Types.VariantType.ByteString,
    Value = "\1\2\3\4\5\6\7\8\9"
  }
  local byteStringArray = {
    Type = ua.Types.VariantType.ByteString,
    IsArray = true,
    Value = {
      "\1\2\3\4\5",
      "\2\3\4\5\6\7",
      "\3\4\5\6\7",
      "\4\5\6\7\8\9",
      "\5\6\7\8\9",
      "\6\7\8\9",
      "\7\8\9\0",
      "\8\9\0",
      "\9\0",
      "\0"
    }
  }
  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "ByteString", byteStringScalar, nextId()),
      ua.newVariableParams(parentNodeId, "ByteStringArray", byteStringArray, nextId())
    }
  }

  addNodes(services, newVariable)
end


local function addXmlElement_Scalar_And_Array(services, parentNodeId)
  traceI("Adding XmlElement scalar and array")

  local xmlScalar = {
    Type = ua.Types.VariantType.XmlElement,
    Value = '<xml version="1.0"><opcua></opcua>'
  }
  local xmlArray = {
    Type = ua.Types.VariantType.XmlElement,
    IsArray = true,
    Value = {
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
      '<xml version="1.0"><opcua></opcua>',
    }
  }

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "XmlElement", xmlScalar, nextId()),
      ua.newVariableParams(parentNodeId, "XmlElementArray", xmlArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end

local function addNodeId_Scalar_And_Array(services, parentNodeId)
  traceI("Adding NodeId scalar and array")

  local nodeIdScalar = {
    Type = ua.Types.VariantType.NodeId,
    Value = "ns=10;s=string_id"
  }
  local nodeIdArray = {
    Type = ua.Types.VariantType.NodeId,
    IsArray = true,
    Value = {
      "ns=11;s=string_id",
      "ns=1;i=10",
      "ns=5;i=6",
      "ns=6;i=5",
      "ns=7;i=4",
      "ns=8;i=3",
      "ns=9;i=2",
    }
  }

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "NodeId", nodeIdScalar, nextId()),
      ua.newVariableParams(parentNodeId, "NodeIdArray", nodeIdArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end


local function addExpandedNodeId_Scalar_And_Array(services, parentNodeId)
  traceI("Adding ExpandedNodeId scalar and array")


  local nodeIdScalar = {
    Type = ua.Types.VariantType.ExpandedNodeId,
    Value = "ns=10;s=expanded_string_id"
  }
  local nodeIdArray = {
    Type = ua.Types.VariantType.ExpandedNodeId,
    IsArray = true,
    Value = {
      "nsu=uri;s=expanded_string_id",
      "ns=1;i=10",
      "ns=5;i=6",
      "ns=6;i=5",
      "ns=7;i=4",
      "ns=8;i=3",
      "ns=9;i=2",
    }
  }

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "ExpandedNodeId", nodeIdScalar, nextId()),
      ua.newVariableParams(parentNodeId, "ExpandedNodeIdArray", nodeIdArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end


local function addStatusCode_Scalar_And_Array(services, parentNodeId)
  traceI("Adding StatusCode variables scalar and array")

  local statusCodeScalar = {
    Type = ua.Types.VariantType.StatusCode,
    Value = s.BadOutOfMemory
  }
  local statusCodeArray = {
    Type = ua.Types.VariantType.StatusCode,
    IsArray = true,
    Value = {
      s.BadOutOfMemory,
      s.BadNodeIdExists,
      s.BadNodeIdUnknown,
      s.BadAttributeIdInvalid,
      s.BadUserAccessDenied,
      s.BadNotWritable,
      s.BadNotReadable,
      s.BadInvalidArgument,
      s.BadInvalidNodeId,
      s.BadInvalidArgument
    }
  }

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "StatusCode", statusCodeScalar, nextId()),
      ua.newVariableParams(parentNodeId, "StatusCodeArray", statusCodeArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end


local function addQualifiedName_Scalar_And_Array(services, parentNodeId)
  traceI("Adding QualifiedName scalar and array")

  local qualifiedNameScalar = {
    Type = ua.Types.VariantType.QualifiedName,
    Value = {Name="QualifiedNameValue", ns=10}
  }
  local qualifiedNameArray = {
    Type = ua.Types.VariantType.QualifiedName,
    IsArray = true,
    Value = {
      {Name="QualifiedName1",ns=1},
      {Name="QualifiedName2",ns=2},
      {Name="QualifiedName3",ns=3},
      {Name="QualifiedName6",ns=6},
      {Name="QualifiedName7",ns=7},
      {Name="QualifiedName8",ns=8},
      {Name="QualifiedName9",ns=9},
      {Name="QualifiedName10",ns=10},
    }
  }

  -- Array with node id attributes of a new QualifiedName variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "QualifiedName", qualifiedNameScalar, nextId()),
      ua.newVariableParams(parentNodeId, "QualifiedNameArray", qualifiedNameArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end


local function addLocalizedText_Scalar_And_Array(services, parentNodeId)
  traceI("Adding LocalizedText scalar and array")

  local localizedTextScalar = {
    Type = ua.Types.VariantType.LocalizedText,
    Value = {Text="LocalizedTextValue", Locale="en-US"}
  }
  local localizedTextArray = {
    Type = ua.Types.VariantType.LocalizedText,
    IsArray = true,
    Value = {
      {Text="LocalizedTextValue0", Locale="en-US"},
      {Text="LocalizedTextValue1", Locale="en-US"},
      {Text="LocalizedTextValue2", Locale="en-US"},
      {Text="LocalizedTextValue3", Locale="en-US"},
      {Text="LocalizedTextValue4", Locale="en-US"},
      {Text="LocalizedTextValue5", Locale="en-US"},
      {Text="LocalizedTextValue6", Locale="en-US"},
      {Text="LocalizedTextValue7", Locale="en-US"},
      {Text="LocalizedTextValue8", Locale="en-US"},
      {Text="LocalizedTextValue9", Locale="en-US"},
    }
  }

  -- Array with node id attributes of a new QualifiedName variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "LocalizedText", localizedTextScalar, nextId()),
      ua.newVariableParams(parentNodeId, "LocalizedTextArray", localizedTextArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end


local function addExtensionObject_Scalar_And_Array(services, parentNodeId)
  traceI("Adding ExtensionObject scalar and array")

  local extensionObjectScalar = {
    Type = ua.Types.VariantType.ExtensionObject,
    Value = {
      TypeId="i=10000",
      Body="\1\2\3\4\5\6"
    }
  }

  local extensionObjectArray = {
    Type = ua.Types.VariantType.ExtensionObject,
    IsArray = true,
    Value = {
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
      {TypeId="i=10000",Body="\1\2\3\4\5\6"},
    }
  }


  -- Array with node id attributes of a new ExtensionObject variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "ExtensionObject", extensionObjectScalar, nextId()),
      ua.newVariableParams(parentNodeId, "ExtensionObjectArray", extensionObjectArray, nextId())
    }
  }

  addNodes(services, newVariable)
end

local function addDataValue_Scalar_And_Array(services, parentNodeId)
  traceI("Adding DataValue scalar and array")

  local dataValue = {
    Type = ua.Types.VariantType.DataValue,
    Value = {
      Type = ua.Types.VariantType.Byte,
      Value=1,
      StatusCode = s.Good,
      SourceTimestamp = os.time() - 1,
      ServerTimestamp = os.time(),
      SourcePicoseconds = 100,
      ServerPicoseconds = 200
    }
  }
  local dataValueScalar = {-- DataValue
    Type = ua.Types.VariantType.DataValue,
    Value = dataValue,
  }

  local dataValueArray = {
    Type = ua.Types.VariantType.DataValue,
    IsArray = true,
    Value = { -- Array of DataValue
      {--#1
        Type = ua.Types.VariantType.Byte,
        Value=1,
        StatusCode = s.Good,
        SourceTimestamp = os.time() - 1,
        ServerTimestamp = os.time(),
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#2
        Type = ua.Types.VariantType.SByte,
        Value=1,
        StatusCode = s.Good,
        SourceTimestamp = os.time() - 1,
        ServerTimestamp = os.time(),
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#3
        Type = ua.Types.VariantType.Int16,
        Value=1,
        StatusCode = s.Good,
        SourceTimestamp = os.time() - 1,
        ServerTimestamp = os.time(),
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#4
        Type = ua.Types.VariantType.UInt16,
        Value=1,
        StatusCode = s.Good,
        SourceTimestamp = os.time() - 1,
        ServerTimestamp = os.time(),
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#5
        Type = ua.Types.VariantType.Double,
        Value=1.1,
        StatusCode = s.Good,
        SourceTimestamp = os.time(),
        ServerTimestamp = os.time() + 1,
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#6
        Type = ua.Types.VariantType.Float,
        Value=1.1,
        StatusCode = s.Good,
        SourceTimestamp = os.time(),
        ServerTimestamp = os.time() + 1,
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#7
        Type = ua.Types.VariantType.UInt64,
        Value=122234567789,
        StatusCode = s.Good,
        SourceTimestamp = os.time(),
        ServerTimestamp = os.time() + 1,
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#8
        Type = ua.Types.VariantType.String,
        Value="StringElement",
        StatusCode = s.Good,
        SourceTimestamp = os.time(),
        ServerTimestamp = os.time() + 1,
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#9
        Type = ua.Types.VariantType.StatusCode,
        Value=s.BadInternalError,
        StatusCode = s.Good,
        SourceTimestamp = os.time(),
        ServerTimestamp = os.time() + 1,
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      },
      {--#10
        Type = ua.Types.VariantType.DateTime,
        Value=os.time(),
        StatusCode = s.Good,
        SourceTimestamp = os.time(),
        ServerTimestamp = os.time() + 1,
        SourcePicoseconds = 100,
        ServerPicoseconds = 200
      }
    }
  }

  -- Array with node id attributes of a new DataValue variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "DataValue",   dataValueScalar, nextId()),
      ua.newVariableParams(parentNodeId, "DataValueArray", dataValueArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end


local function addDiagnosticInfo_Scalar_And_Array(services, parentNodeId)
  traceI("Adding DiagnosticInfo scalar and array")

  local diagnosticInfo = {
    SymbolicId = -1,
    NsUri = -1,
    Locale = -1,
    LocalizedText = -1,
    AdditionalInfo = "AdditionalInfo",
    InnerStatusCode = s.BadNodeAttributesInvalid,
    InnerDiagnosticInfo = {
      SymbolicId = -1,
      NsUri = -1,
      Locale = -1,
      LocalizedText = -1,
      AdditionalInfo = "InnerAdditionalInfo",
      InnerStatusCode = s.BadNodeAttributesInvalid,
    }
  }

  local diagnosticInfoScalar = { --DataValue
    Type = ua.Types.VariantType.DiagnosticInfo,
    Value = diagnosticInfo,
  }

  local diagnosticInfoArray = { --DataValueArray
    Type = ua.Types.VariantType.DiagnosticInfo,
    IsArray = true,
    Value = {
      diagnosticInfo,
      diagnosticInfo,
      diagnosticInfo,
      diagnosticInfo,
      diagnosticInfo,
      diagnosticInfo,
      diagnosticInfo,
      diagnosticInfo,
    }
  }

  -- Array with node id attributes of a new DataValue variable
  local newVariable = {
    NodesToAdd = {
      ua.newVariableParams(parentNodeId, "DiagnosticInfo", diagnosticInfoScalar, nextId()),
      ua.newVariableParams(parentNodeId, "DiagnosticInfoArray", diagnosticInfoArray, nextId()),
    }
  }

  addNodes(services, newVariable)
end

local function addVaraibleFolder(services, parentNodeId)
  traceI("Adding folder 'Variables' under which variable nodes will be placed.")
  local folderId = nextId()
  local folderParams = ua.newFolderParams(parentNodeId, "Variables", folderId)
  local request = {
    NodesToAdd = {folderParams}
  }

  local resp = services:addNodes(request)
  local res = resp.Results
  if res[1].StatusCode ~= ua.StatusCode.Good and res[1].StatusCode ~= ua.StatusCode.BadNodeIdExists then
    error(res.StatusCode)
  end

  return folderId
end

local function variables(services, parentNodeId)

  if services.config.logging.services.infOn then
    traceI = ua.trace.inf
  else
    traceI = function() end
  end

  local variablesFolderId = addVaraibleFolder(services, parentNodeId)
  addBoolean(services, variablesFolderId)
  addBooleanArray(services, variablesFolderId)
  addByte(services, variablesFolderId)
  addByteArray(services, variablesFolderId)
  addSByte(services, variablesFolderId)
  addSByteArray(services, variablesFolderId)
  addInt16(services, variablesFolderId)
  addInt16Array(services, variablesFolderId)
  addUInt16_Scalar_And_Array(services, variablesFolderId)
  addInt32_UInt32_Scalar_And_Array(services, variablesFolderId)
  addInt64_UInt64_Scalar_And_Array(services, variablesFolderId)
  addFloat_Double_Scalar_And_Array(services, variablesFolderId)
  addString_Scalar_And_Array(services, variablesFolderId)
  addGuid_Scalar_And_Array(services, variablesFolderId)
  addDateTime_Scalar_And_Array(services, variablesFolderId)
  addByteString_Scalar_And_Array(services, variablesFolderId)
  addXmlElement_Scalar_And_Array(services, variablesFolderId)
  addNodeId_Scalar_And_Array(services, variablesFolderId)
  addExpandedNodeId_Scalar_And_Array(services, variablesFolderId)
  addStatusCode_Scalar_And_Array(services, variablesFolderId)
  addQualifiedName_Scalar_And_Array(services, variablesFolderId)
  addLocalizedText_Scalar_And_Array(services, variablesFolderId)
  addExtensionObject_Scalar_And_Array(services, variablesFolderId)
  addDataValue_Scalar_And_Array(services, variablesFolderId)
  addDiagnosticInfo_Scalar_And_Array(services, variablesFolderId)
end

return variables
