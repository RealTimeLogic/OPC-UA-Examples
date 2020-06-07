local ua = require("opcua.api")
local s = ua.Status

local traceI = ua.trace.inf

local function Add(client, newVariable)
  local statusCode, results = client:addNodes(newVariable)
  if statusCode == ua.Status.Good then
    for i,res in ipairs(results) do
      assert(res.statusCode == ua.Status.Good, string.format("Failed to add node '%s': 0x%X", newVariable.nodesToAdd[i].browseName.name, res.statusCode))
      traceI(string.format("   AddedNodeId: %s", ua.NodeId.toString(res.addedNodeId)))
    end
  else
    error(string.format("  AddNode request failed with error: %x", statusCode))
  end
end

local function Add_Boolean(client, parentNodeId)
  traceI("Adding Boolean variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="boolean_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Boolean"},
          description = {text="Example of Boolean Scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {boolean=true},
          dataType = ua.NodeIds.Boolean,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end

local function Add_BooleanArray(client, parentNodeId)
  traceI("Adding Boolean Array variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="boolean_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="BooleanArray"},
          description = {text="Example of Boolean Array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {boolean={true,false,true,false,true,false,true,false,true,false}},
          dataType = ua.NodeIds.Boolean,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_Byte(client, parentNodeId)
  traceI("Adding Byte variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="byte_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Byte"},
          description = {text="Example of Byte Scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {byte=17},
          dataType = ua.NodeIds.Byte,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_ByteArray(client, parentNodeId)
  traceI("Adding Byte Array variable")

  local data = {1,2,3,4,5,6,7,8,9,10}
  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="byte_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ByteArray"},
          description = {text="Example of Byte Array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {byte=data},
          dataType = ua.NodeIds.Byte,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {#data},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end



local function Add_SByte(client, parentNodeId)
  traceI("Adding SByte variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="sbyte_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="SByte"},
          description = {text="Example of SByte scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {sbyte=-100},
          dataType = ua.NodeIds.SByte,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_SByteArray(client, parentNodeId)
  traceI("Adding SByte Array variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="sbyte_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="SByteArray"},
          description = {text="Example of SByte array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {sbyte={-2,-1,0,1,2,3,4,5,6,7}},
          dataType = ua.NodeIds.SByte,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_Int16(client, parentNodeId)
  traceI("Adding Int16 variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="int16_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Int16"},
          description = {text="Example of Int16 scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {int16=30000},
          dataType = ua.NodeIds.Int16,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end

local function Add_Int16Array(client, parentNodeId)
  traceI("Adding Int16 Array variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="int16_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Int16Array"},
          description = {text="Example of Int16 array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {int16={-2000,-1000,0,100,200,300,400,5000,6000,7000}},
          dataType = ua.NodeIds.Int16,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end



local function Add_UInt16_Scalar_And_Array(client, parentNodeId)
  traceI("Adding UInt16 variable and UInt16 array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="uint16_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="UInt16"},
          description = {text="Example of UInt16 scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {uint16=30000},
          dataType = ua.NodeIds.UInt16,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="uint16_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="UInt16Array"},
          description = {text="Example of UInt16 array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {uint16={2000,1000,0,100,200,300,400,5000,6000,40000}},
          dataType = ua.NodeIds.UInt16,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }

    }
  }

  Add(client, newVariable)
end


local function Add_Int32_UInt32_Scalar_And_Array(client, parentNodeId)
  traceI("Adding Int32,UInt32 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="uint32_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="UInt32"},
          description = {text="Example of UInt16 scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {uint32=30000},
          dataType = ua.NodeIds.UInt32,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="uint32_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="UInt32Array"},
          description = {text="Example of UInt32 array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {uint32={2000,1000,0,100,200,300,4000000,5000,6000,40000}},
          dataType = ua.NodeIds.UInt32,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #3
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="int32_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Int32"},
          description = {text="Example of Int32 scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {int32=30000},
          dataType = ua.NodeIds.Int32,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #4
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="int32_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Int32Array"},
          description = {text="Example of Int32 array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {int32={-2000,1000,0,100,-200,300,-4000000,5000,6000,40000}},
          dataType = ua.NodeIds.Int32,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end



local function Add_Int64_UInt64_Scalar_And_Array(client, parentNodeId)
  traceI("Adding Int64,UInt64 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="uint64_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="UInt64"},
          description = {text="Example of UInt64 scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {uint64=3000000000},
          dataType = ua.NodeIds.UInt64,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="uint64_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="UInt64Array"},
          description = {text="Example of UInt64 array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {uint64={2000,1000,0,100,200,300,4000000000,5000,6000,40000}},
          dataType = ua.NodeIds.UInt64,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #3
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="int64_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Int64"},
          description = {text="Example of Int64 scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {int64=1000000000},
          dataType = ua.NodeIds.Int64,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #4
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="int64_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Int64Array"},
          description = {text="Example of Int64 array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {int64={-2000,1000,0,100,-200,300,-10000000000,5000,6000,40000}},
          dataType = ua.NodeIds.Int64,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_Float_Double_Scalar_And_Array(client, parentNodeId)
  traceI("Adding Float,Double scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="float_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Float"},
          description = {text="Example of Float scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {float=3000000000},
          dataType = ua.NodeIds.Float,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="float_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="FloatArray"},
          description = {text="Example of Float array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {float={0.1,-2.2,3.3,-4.4,5.5,6.6,-7.7,8.8,9.9,0}},
          dataType = ua.NodeIds.Float,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #3
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="double_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Double"},
          description = {text="Example of Double scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {double=1000000000},
          dataType = ua.NodeIds.Double,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #4
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="double_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DoubleArray"},
          description = {text="Example of Double array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {double={-0.0,13.4,5,100.1,-12345679.123456789,987654321.123456789,-10000000000,5000,6000,40000}},
          dataType = ua.NodeIds.Double,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_String_Scalar_And_Array(client, parentNodeId)
  traceI("Adding String scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="string_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="String"},
          description = {text="String scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {string="This is a string variable"},
          dataType = ua.NodeIds.String,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="string_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="StringArray"},
          description = {text="Example of String array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {string={"Element1", "Element2", "Element3", "Element4", "Element5", "Element6", "Element7", "Element8", "Element9", "Element10"}},
          dataType = ua.NodeIds.String,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end

local num = 0
local function Guid()
  num = num + 1
  return {
    data1=num,
    data2=num,
    data3=num,
    data4=num,
    data5=num,
    data6=num,
    data7=num,
    data8=num,
    data9=num,
    data10=num,
    data11=num
  }
end
local function Add_Guid_Scalar_And_Array(client, parentNodeId)
  traceI("Adding Guid scalar and array")

  -- Array with node id attributes of a new variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="guid_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="Guid"},
          description = {text="Guid scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {guid=Guid()},
          dataType = ua.NodeIds.Guid,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="guid_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="GuidArray"},
          description = {text="Example of Guid array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {guid={Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid()}},
          dataType = ua.NodeIds.Guid,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_DateTime_Scalar_And_Array(client, parentNodeId)
  traceI("Adding DateTime scalar and array")

  local curTime = os.time()

  -- Array with node id attributes of a new variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="datetime_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DateTime"},
          description = {text="DateTime scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {dateTime=curTime + 0.123},
          dataType = ua.NodeIds.DateTime,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="datetime_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DateTimeArray"},
          description = {text="Example of DateTime array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {dateTime={curTime,curTime+0.1,curTime+0.2,curTime+0.3,curTime+0.4,curTime+0.5,curTime+0.6,curTime+0.7,curTime+0.8,curTime+0.9}},
          dataType = ua.NodeIds.DateTime,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end

local function Add_ByteString_Scalar_And_Array(client, parentNodeId)
  traceI("Adding ByteString scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="bytestring_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ByteString"},
          description = {text="ByteString scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {byteString={1,2,3,4,5,6,7,8,9}},
          dataType = ua.NodeIds.ByteString,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="bytestring_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ByteStringArray"},
          description = {text="Example of ByteString array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {byteString={{1,2,3,4,5}, {2,3,4,5,6,7}, {3,4,5,6,7}, {4,5,6,7,8,9}, {5,6,7,8,9}, {6,7,8,9}, {7,8,9,0}, {8,9,0}, {9,0}, {0}} },
          dataType = ua.NodeIds.ByteString,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_XmlElement_Scalar_And_Array(client, parentNodeId)
  traceI("Adding XmlElement scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="xmlelement_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="XmlElement"},
          description = {text="XmlElement scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {xmlElement={value="asdfasdfasd"}},
          dataType = ua.NodeIds.XmlElement,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="xmlelement_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="XmlElementArray"},
          description = {text="Example of XmlElement array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {xmlElement={
            {value="12345"},
            {value="23456"},
            {value="34678"},
            {value="4578"},
            {value="56899"},
            {value="2345234523"},
            {value='<xml version="1.0"><opcua></opcua>'},
            {value="7654"},
            {value="hmmm"},
            {value='123415546'}
           }},
          dataType = ua.NodeIds.XmlElement,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end

local function Add_NodeId_Scalar_And_Array(client, parentNodeId)
  traceI("Adding NodeId scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="nodeid_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="NodeId"},
          description = {text="NodeId scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {nodeId={id="string_id", nsi=10}},
          dataType = ua.NodeIds.NodeId,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="nodeid_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="NodeIdArray"},
          description = {text="Example of NodeId array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {
            nodeId={
              {id="string_id", nsi=11},
              {id=1, nsi=10},
              {id=2, nsi=9},
              {id=3, nsi=8},
              {id=4, nsi=7},
              {id=5, nsi=6},
              {id=6, nsi=5},
              {id=7, nsi=4},
              {id=8, nsi=3},
              {id=9, nsi=2},
            }
          },
          dataType = ua.NodeIds.NodeId,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_ExpandedNodeId_Scalar_And_Array(client, parentNodeId)
  traceI("Adding ExpandedNodeId scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="expanded_nodeid_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ExpandedNodeId"},
          description = {text="ExpadedNodeId scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {expandedNodeId={id="expanded_string_id", nsi=10}},
          dataType = ua.NodeIds.ExpandedNodeId,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="expaded_nodeid_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ExpandedNodeIdArray"},
          description = {text="Example of ExpandedNodeId array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {
            expandedNodeId={
              {id="expanded_string_id", nsi=11},
              {id=1, nsi=10},
              {id=2, nsi=9},
              {id=3, nsi=8},
              {id=4, nsi=7},
              {id=5, nsi=6},
              {id=6, nsi=5},
              {id=7, nsi=4},
              {id=8, nsi=3},
              {id=9, nsi=2},
            }
          },
          dataType = ua.NodeIds.ExpandedNodeId,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_StatusCode_Scalar_And_Array(client, parentNodeId)
  traceI("Adding Int32,UInt32 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="statuscode_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="StatusCode"},
          description = {text="Example of StatusCode scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {statusCode=s.BadOutOfMemory},
          dataType = ua.NodeIds.StatusCode,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="statuscode_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="StatusCodeArray"},
          description = {text="Example of StatusCode array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {statusCode={
            s.BadUnexpectedError,
            s.BadInternalError,
            s.BadOutOfMemory,
            s.BadResourceUnavailable,
            s.BadCommunicationError,
            s.BadEncodingError,
            s.BadDecodingError,
            s.BadEncodingLimitsExceeded,
            s.BadRequestTooLarge,
            s.BadResponseTooLarge
          }},
          dataType = ua.NodeIds.StatusCode,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_QualifiedName_Scalar_And_Array(client, parentNodeId)
  traceI("Adding QualifiedName scalar and array")

  -- Array with node id attributes of a new QualifiedName variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="qualifiedname_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="QualifiedName"},
          description = {text="Example of QualifiedName scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {qualifiedName={name="QualifiedNameValue", nsi=10}},
          dataType = ua.NodeIds.QualifiedName,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="qualifiedname_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="QualifiedNameArray"},
          description = {text="Example of QualifiedName array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {qualifiedName={
            {name="QualifiedName1",nsi=1},
            {name="QualifiedName2",nsi=2},
            {name="QualifiedName3",nsi=3},
            {name="QualifiedName4",nsi=4},
            {name="QualifiedName5",nsi=5},
            {name="QualifiedName6",nsi=6},
            {name="QualifiedName7",nsi=7},
            {name="QualifiedName8",nsi=8},
            {name="QualifiedName9",nsi=9},
            {name="QualifiedName10",nsi=10},
          }},
          dataType = ua.NodeIds.QualifiedName,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_LocalizedText_Scalar_And_Array(client, parentNodeId)
  traceI("Adding LocalizedText scalar and array")

  -- Array with node id attributes of a new QualifiedName variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="localizedtext_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="LocalizedText"},
          description = {text="Example of LocalizedText scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {localizedText={text="LocalizedTextScalar", locale="en-US"}},
          dataType = ua.NodeIds.LocalizedText,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="localizedtext_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="LocalizedTextArray"},
          description = {text="Example of LocalizedText array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {localizedText={
            {text="LocalizedTextValue0", locale="en-US"},
            {text="LocalizedTextValue1", locale="en-US"},
            {text="LocalizedTextValue2", locale="en-US"},
            {text="LocalizedTextValue3", locale="en-US"},
            {text="LocalizedTextValue4", locale="en-US"},
            {text="LocalizedTextValue5", locale="en-US"},
            {text="LocalizedTextValue6", locale="en-US"},
            {text="LocalizedTextValue7", locale="en-US"},
            {text="LocalizedTextValue8", locale="en-US"},
            {text="LocalizedTextValue9", locale="en-US"},
          }},
          dataType = ua.NodeIds.LocalizedText,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_ExtensionObject_Scalar_And_Array(client, parentNodeId)
  traceI("Adding ExtensionObject scalar and array")

  -- Array with node id attributes of a new ExtensionObject variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="extension_object_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ExtensionObject"},
          description = {text="Example of ExtensionObject scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {
            extensionObject={
              typeId="i=10000",
              body={1,2,3,4,5,6}
            }
          },
          dataType = ua.NodeIds.Byte,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="extension_object_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="ExtensionObjectArray"},
          description = {text="Example of ExtensionObject array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {extensionObject={
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
            {typeId="i=10000",body={1,2,3,4,5,6}},
          }},
          dataType = ua.NodeIds.Byte,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end

local function Add_DataValue_Scalar_And_Array(client, parentNodeId)
  traceI("Adding DataValue scalar and array")

  -- Array with node id attributes of a new DataValue variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="datavalue_object_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DataValue"},
          description = {text="Example of DataValue scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {
            dataValue={
              value={ byte=1 },
              statusCode = s.Good,
              sourceTimestamp = os.time() - 1,
              serverTimestamp = os.time(),
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            }
          },
          dataType = ua.NodeIds.DataValue,
          valueRank = -1,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="datavalue_object_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DataValueArray"},
          description = {text="Example of DataValue array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {dataValue={
            {--#1
              value={ byte=1 },
              statusCode = s.Good,
              sourceTimestamp = os.time() - 1,
              serverTimestamp = os.time(),
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#2
              value={ sbyte=1 },
              statusCode = s.Good,
              sourceTimestamp = os.time() - 1,
              serverTimestamp = os.time(),
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#3
              value={ int16=1 },
              statusCode = s.Good,
              sourceTimestamp = os.time() - 1,
              serverTimestamp = os.time(),
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#4
              value={ uint16=1 },
              statusCode = s.Good,
              sourceTimestamp = os.time() - 1,
              serverTimestamp = os.time(),
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#5
              value={ double=1.1 },
              statusCode = s.Good,
              sourceTimestamp = os.time(),
              serverTimestamp = os.time() + 1,
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#6
              value={ float=1.1 },
              statusCode = s.Good,
              sourceTimestamp = os.time(),
              serverTimestamp = os.time() + 1,
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#7
              value={ uint64=122234567789},
              statusCode = s.Good,
              sourceTimestamp = os.time(),
              serverTimestamp = os.time() + 1,
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#8
              value={ string="StringElement"},
              statusCode = s.Good,
              sourceTimestamp = os.time(),
              serverTimestamp = os.time() + 1,
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#9
              value={ statusCode=s.BadInternalError},
              statusCode = s.Good,
              sourceTimestamp = os.time(),
              serverTimestamp = os.time() + 1,
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            },
            {--#10
              value={ dateTime=os.time()},
              statusCode = s.Good,
              sourceTimestamp = os.time(),
              serverTimestamp = os.time() + 1,
              sourcePicoseconds = 100,
              serverPicoseconds = 200
            }
          }},
          dataType = ua.NodeIds.DataValue,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_DiagnosticInfo_Scalar_And_Array(client, parentNodeId)
  traceI("Adding DiagnosticInfo scalar and array")

  -- Array with node id attributes of a new DataValue variable
  local newVariable = {
    nodesToAdd = {
      { -- #1
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="disgnosticinfo_object_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DiagnosticInfo"},
          description = {text="Example of DiagnosticInfo scalar variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {
            diagnosticInfo = {
              symbolicId = -1,
              nsUri = -1,
              locale = -1,
              localizedText = -1,
              additionalInfo = "AdditionalInfo",
              innerStatusCode = s.BadNodeAttributesInvalid,
              innerDiagnosticInfo = {
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "InnerAdditionalInfo",
                innerStatusCode = s.BadNodeAttributesInvalid,
              }
            }
          },
          dataType = ua.NodeIds.DiagnosticInfo,
          valueRank = ua.Types.ValueRank.Scalar,
          arrayDimensions = nil,
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        parentNodeId = parentNodeId,
        referenceTypeId = ua.NodeIds.Organizes,
        requestedNewNodeId = ua.NodeId.Null,
        browseName = {name="diagnosticinfo_object_array_variable", nsi=0},
        nodeClass = ua.Types.NodeClass.Variable,
        nodeAttributes = {
          displayName = {text="DiagnosticInfoArray"},
          description = {text="Example of DiagnosticInfo array variable"},
          writeMask = 0,
          userWriteMask = 0,
          value = {
            diagnosticInfo={
              {--#1
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo1",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo12",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#2
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo2",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo22",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#3
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo3",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  dymbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo32",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#4
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo4",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo42",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#5
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo5",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo52",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#6
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo6",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo62",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#7
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo7",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo72",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#8
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo8",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo82",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#9
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                AdditionalInfo = "AdditionalInfo9",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo92",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#10
                symbolicId = -1,
                nsUri = -1,
                locale = -1,
                localizedText = -1,
                additionalInfo = "AdditionalInfo10",
                innerStatusCode = s.BadNodeAttributesInvalid,
                innerDiagnosticInfo = {
                  symbolicId = -1,
                  nsUri = -1,
                  locale = -1,
                  localizedText = -1,
                  additionalInfo = "InnerAdditionalInfo102",
                  innerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
            }
          },
          dataType = ua.NodeIds.DiagnosticInfo,
          valueRank = ua.Types.ValueRank.OneDimension,
          arrayDimensions = {10},
          accessLevel = 0,
          userAccessLevel = 0,
          minimumSamplingInterval = 1000,
          historizing = 0
        },
        typeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end

local function Variables(services, parentNodeId)
  Add_Boolean(services, parentNodeId)
  Add_BooleanArray(services, parentNodeId)
  Add_Byte(services, parentNodeId)
  Add_ByteArray(services, parentNodeId)
  Add_SByte(services, parentNodeId)
  Add_SByteArray(services, parentNodeId)
  Add_Int16(services, parentNodeId)
  Add_Int16Array(services, parentNodeId)
  Add_UInt16_Scalar_And_Array(services, parentNodeId)
  Add_Int32_UInt32_Scalar_And_Array(services, parentNodeId)
  Add_Int64_UInt64_Scalar_And_Array(services, parentNodeId)
  Add_Float_Double_Scalar_And_Array(services, parentNodeId)
  Add_String_Scalar_And_Array(services, parentNodeId)
  Add_ByteString_Scalar_And_Array(services, parentNodeId)
  Add_Guid_Scalar_And_Array(services, parentNodeId)
  Add_DateTime_Scalar_And_Array(services, parentNodeId)
  Add_XmlElement_Scalar_And_Array(services, parentNodeId)
  Add_NodeId_Scalar_And_Array(services, parentNodeId)
  Add_ExpandedNodeId_Scalar_And_Array(services, parentNodeId)
  Add_StatusCode_Scalar_And_Array(services, parentNodeId)
  Add_QualifiedName_Scalar_And_Array(services, parentNodeId)
  Add_LocalizedText_Scalar_And_Array(services, parentNodeId)
  Add_ExtensionObject_Scalar_And_Array(services, parentNodeId)
  Add_DataValue_Scalar_And_Array(services, parentNodeId)
  Add_DiagnosticInfo_Scalar_And_Array(services, parentNodeId)
  return s.Good
end

return Variables
