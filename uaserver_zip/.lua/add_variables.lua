local ua = require("opcua.api")
local s = ua.Status

local function Add(client, newVariable)
  local statusCode, results = client:AddNodes(newVariable)
  if statusCode == ua.Status.Good then
    for i,res in ipairs(results) do
      assert(res.StatusCode == ua.Status.Good, string.format("Failed to add node '%s': 0x%X", newVariable.NodesToAdd[i].BrowseName.Name, res.StatusCode))
      ua.Log.I(string.format("   AddedNodeId: %s", ua.NodeId.ToString(res.AddedNodeId)))
    end
  else
    error(string.format("  AddNode request failed with error: %x", statusCode))
  end
end

local function Add_Boolean(client, parentNodeId)
  ua.Log.I("Adding Boolean variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="boolean_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Boolean"},
          Description = {Text="Example of Boolean Scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Boolean=true},
          DataType = ua.NodeIds.Boolean,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end

local function Add_BooleanArray(client, parentNodeId)
  ua.Log.I("Adding Boolean Array variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="boolean_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="BooleanArray"},
          Description = {Text="Example of Boolean Array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Boolean={true,false,true,false,true,false,true,false,true,false}},
          DataType = ua.NodeIds.Boolean,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end


local function Add_Byte(client, parentNodeId)
  ua.Log.I("Adding Byte variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="byte_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Byte"},
          Description = {Text="Example of Byte Scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Byte=17},
          DataType = ua.NodeIds.Byte,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end


local function Add_ByteArray(client, parentNodeId)
  ua.Log.I("Adding Byte Array variable")

  local data = {1,2,3,4,5,6,7,8,9,10}
  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="byte_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ByteArray"},
          Description = {Text="Example of Byte Array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Byte=data},
          DataType = ua.NodeIds.Byte,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {#data},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end



local function Add_SByte(client, parentNodeId)
  ua.Log.I("Adding SByte variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="sbyte_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="SByte"},
          Description = {Text="Example of SByte scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {SByte=-100},
          DataType = ua.NodeIds.SByte,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end


local function Add_SByteArray(client, parentNodeId)
  ua.Log.I("Adding SByte Array variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="sbyte_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="SByteArray"},
          Description = {Text="Example of SByte array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {SByte={-2,-1,0,1,2,3,4,5,6,7}},
          DataType = ua.NodeIds.SByte,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end


local function Add_Int16(client, parentNodeId)
  ua.Log.I("Adding Int16 variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="int16_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Int16"},
          Description = {Text="Example of Int16 scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Int16=30000},
          DataType = ua.NodeIds.Int16,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end

local function Add_Int16Array(client, parentNodeId)
  ua.Log.I("Adding Int16 Array variable")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="int16_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Int16Array"},
          Description = {Text="Example of Int16 array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Int16={-2000,-1000,0,100,200,300,400,5000,6000,7000}},
          DataType = ua.NodeIds.Int16,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }
  
  Add(client, newVariable)
end



local function Add_UInt16_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding UInt16 variable and UInt16 array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="uint16_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="UInt16"},
          Description = {Text="Example of UInt16 scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {UInt16=30000},
          DataType = ua.NodeIds.UInt16,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="uint16_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="UInt16Array"},
          Description = {Text="Example of UInt16 array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {UInt16={2000,1000,0,100,200,300,400,5000,6000,40000}},
          DataType = ua.NodeIds.UInt16,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }

    }
  }

  Add(client, newVariable)
end


local function Add_Int32_UInt32_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding Int32,UInt32 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="uint32_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="UInt32"},
          Description = {Text="Example of UInt16 scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {UInt32=30000},
          DataType = ua.NodeIds.UInt32,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="uint32_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="UInt32Array"},
          Description = {Text="Example of UInt32 array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {UInt32={2000,1000,0,100,200,300,4000000,5000,6000,40000}},
          DataType = ua.NodeIds.UInt32,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #3
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="int32_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Int32"},
          Description = {Text="Example of Int32 scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Int32=30000},
          DataType = ua.NodeIds.Int32,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #4
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="int32_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Int32Array"},
          Description = {Text="Example of Int32 array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Int32={-2000,1000,0,100,-200,300,-4000000,5000,6000,40000}},
          DataType = ua.NodeIds.Int32,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end



local function Add_Int64_UInt64_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding Int64,UInt64 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="uint64_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="UInt64"},
          Description = {Text="Example of UInt64 scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {UInt64=3000000000},
          DataType = ua.NodeIds.UInt64,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="uint64_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="UInt64Array"},
          Description = {Text="Example of UInt64 array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {UInt64={2000,1000,0,100,200,300,4000000000,5000,6000,40000}},
          DataType = ua.NodeIds.UInt64,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #3
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="int64_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Int64"},
          Description = {Text="Example of Int64 scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Int64=1000000000},
          DataType = ua.NodeIds.Int64,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #4
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="int64_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Int64Array"},
          Description = {Text="Example of Int64 array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Int64={-2000,1000,0,100,-200,300,-10000000000,5000,6000,40000}},
          DataType = ua.NodeIds.Int64,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_Float_Double_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding Float,Double scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="float_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Float"},
          Description = {Text="Example of Float scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Float=3000000000},
          DataType = ua.NodeIds.Float,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="float_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="FloatArray"},
          Description = {Text="Example of Float array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Float={0.1,-2.2,3.3,-4.4,5.5,6.6,-7.7,8.8,9.9,0}},
          DataType = ua.NodeIds.Float,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #3
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="double_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Double"},
          Description = {Text="Example of Double scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Double=1000000000},
          DataType = ua.NodeIds.Double,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #4
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="double_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DoubleArray"},
          Description = {Text="Example of Double array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Double={-0.0,13.4,5,100.1,-12345679.123456789,987654321.123456789,-10000000000,5000,6000,40000}},
          DataType = ua.NodeIds.Double,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_String_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding String scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="string_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="String"},
          Description = {Text="String scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {String="This is a string variable"},
          DataType = ua.NodeIds.String,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="string_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="StringArray"},
          Description = {Text="Example of String array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {String={"Element1", "Element2", "Element3", "Element4", "Element5", "Element6", "Element7", "Element8", "Element9", "Element10"}},
          DataType = ua.NodeIds.String,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end

local num = 0
local function Guid()
  num = num + 1
  return {
    Data1=num,
    Data2=num,
    Data3=num,
    Data4=num,
    Data5=num,
    Data6=num,
    Data7=num,
    Data8=num,
    Data9=num,
    Data10=num,
    Data11=num
  }
end
local function Add_Guid_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding Guid scalar and array")

  -- Array with node id attributes of a new variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="guid_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="Guid"},
          Description = {Text="Guid scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Guid=Guid()},
          DataType = ua.NodeIds.Guid,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="guid_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="GuidArray"},
          Description = {Text="Example of Guid array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {Guid={Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid(),Guid()}},
          DataType = ua.NodeIds.Guid,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_DateTime_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding DateTime scalar and array")

  local curTime = os.time()

  -- Array with node id attributes of a new variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="datetime_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DateTime"},
          Description = {Text="DateTime scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {DateTime=curTime + 0.123},
          DataType = ua.NodeIds.DateTime,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="datetime_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DateTimeArray"},
          Description = {Text="Example of DateTime array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {DateTime={curTime,curTime+0.1,curTime+0.2,curTime+0.3,curTime+0.4,curTime+0.5,curTime+0.6,curTime+0.7,curTime+0.8,curTime+0.9}},
          DataType = ua.NodeIds.DateTime,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end

local function Add_ByteString_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding ByteString scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="bytestring_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ByteString"},
          Description = {Text="ByteString scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {ByteString={1,2,3,4,5,6,7,8,9}},
          DataType = ua.NodeIds.ByteString,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="bytestring_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ByteStringArray"},
          Description = {Text="Example of ByteString array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {ByteString={{1,2,3,4,5}, {2,3,4,5,6,7}, {3,4,5,6,7}, {4,5,6,7,8,9}, {5,6,7,8,9}, {6,7,8,9}, {7,8,9,0}, {8,9,0}, {9,0}, {0}} },
          DataType = ua.NodeIds.ByteString,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_XmlElement_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding XmlElement scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="xmlelement_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="XmlElement"},
          Description = {Text="XmlElement scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {XmlElement={Value="asdfasdfasd"}},
          DataType = ua.NodeIds.XmlElement,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="xmlelement_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="XmlElementArray"},
          Description = {Text="Example of XmlElement array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {XmlElement={
            {Value="12345"}, 
            {Value="23456"},
            {Value="34678"},
            {Value="4578"},
            {Value="56899"},
            {Value="2345234523"},
            {Value='<xml version="1.0"><opcua></opcua>'},
            {Value="7654"},
            {Value="hmmm"},
            {Value='123415546'}
           }},
          DataType = ua.NodeIds.XmlElement,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end

local function Add_NodeId_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding NodeId scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="nodeid_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="NodeId"},
          Description = {Text="NodeId scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {NodeId={Identifier="string_id", NamespaceIndex=10}},
          DataType = ua.NodeIds.NodeId,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="nodeid_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="NodeIdArray"},
          Description = {Text="Example of NodeId array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {
            NodeId={
              {Identifier="string_id", NamespaceIndex=11},
              {Identifier=1, NamespaceIndex=10},
              {Identifier=2, NamespaceIndex=9},
              {Identifier=3, NamespaceIndex=8},
              {Identifier=4, NamespaceIndex=7},
              {Identifier=5, NamespaceIndex=6},
              {Identifier=6, NamespaceIndex=5},
              {Identifier=7, NamespaceIndex=4},
              {Identifier=8, NamespaceIndex=3},
              {Identifier=9, NamespaceIndex=2},
            }
          },
          DataType = ua.NodeIds.NodeId,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_ExpandedNodeId_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding ExpandedNodeId scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="expanded_nodeid_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ExpandedNodeId"},
          Description = {Text="ExpadedNodeId scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {ExpandedNodeId={Identifier="expanded_string_id", NamespaceIndex=10}},
          DataType = ua.NodeIds.ExpandedNodeId,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="expaded_nodeid_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ExpandedNodeIdArray"},
          Description = {Text="Example of ExpandedNodeId array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {
            ExpandedNodeId={
              {Identifier="expanded_string_id", NamespaceIndex=11},
              {Identifier=1, NamespaceIndex=10},
              {Identifier=2, NamespaceIndex=9},
              {Identifier=3, NamespaceIndex=8},
              {Identifier=4, NamespaceIndex=7},
              {Identifier=5, NamespaceIndex=6},
              {Identifier=6, NamespaceIndex=5},
              {Identifier=7, NamespaceIndex=4},
              {Identifier=8, NamespaceIndex=3},
              {Identifier=9, NamespaceIndex=2},
            }
          },
          DataType = ua.NodeIds.ExpandedNodeId,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
    }
  }

  Add(client, newVariable)
end


local function Add_StatusCode_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding Int32,UInt32 scalar and array")

  -- Array with node id attributes of a new boolean variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="statuscode_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="StatusCode"},
          Description = {Text="Example of StatusCode scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {StatusCode=s.BadOutOfMemory},
          DataType = ua.NodeIds.StatusCode,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="statuscode_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="StatusCodeArray"},
          Description = {Text="Example of StatusCode array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {StatusCode={
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
          DataType = ua.NodeIds.StatusCode,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_QualifiedName_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding QualifiedName scalar and array")

  -- Array with node id attributes of a new QualifiedName variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="qualifiedname_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="QualifiedName"},
          Description = {Text="Example of QualifiedName scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {QualifiedName={Name="QualifiedNameValue", NamespaceIndex=10}},
          DataType = ua.NodeIds.QualifiedName,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="qualifiedname_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="QualifiedNameArray"},
          Description = {Text="Example of QualifiedName array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {QualifiedName={
            {Name="QualifiedName1",NamespaceIndex=1},
            {Name="QualifiedName2",NamespaceIndex=2},
            {Name="QualifiedName3",NamespaceIndex=3},
            {Name="QualifiedName4",NamespaceIndex=4},
            {Name="QualifiedName5",NamespaceIndex=5},
            {Name="QualifiedName6",NamespaceIndex=6},
            {Name="QualifiedName7",NamespaceIndex=7},
            {Name="QualifiedName8",NamespaceIndex=8},
            {Name="QualifiedName9",NamespaceIndex=9},
            {Name="QualifiedName10",NamespaceIndex=10},
          }},
          DataType = ua.NodeIds.QualifiedName,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_LocalizedText_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding LocalizedText scalar and array")

  -- Array with node id attributes of a new QualifiedName variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="localizedtext_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="LocalizedText"},
          Description = {Text="Example of LocalizedText scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {LocalizedText={Text="LocalizedTextScalar", Locale="en-US"}},
          DataType = ua.NodeIds.LocalizedText,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="localizedtext_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="LocalizedTextArray"},
          Description = {Text="Example of LocalizedText array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {LocalizedText={
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
          }},
          DataType = ua.NodeIds.LocalizedText,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_ExtensionObject_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding ExtensionObject scalar and array")

  -- Array with node id attributes of a new ExtensionObject variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="extension_object_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ExtensionObject"},
          Description = {Text="Example of ExtensionObject scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {
            ExtensionObject={
              TypeId="i=10000",
              Body={1,2,3,4,5,6}
            }
          },
          DataType = ua.NodeIds.Byte,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="extension_object_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="ExtensionObjectArray"},
          Description = {Text="Example of ExtensionObject array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {ExtensionObject={
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
            {TypeId="i=10000",Body={1,2,3,4,5,6}},
          }},
          DataType = ua.NodeIds.Byte,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end

local function Add_DataValue_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding DataValue scalar and array")

  -- Array with node id attributes of a new DataValue variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="datavalue_object_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DataValue"},
          Description = {Text="Example of DataValue scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {
            DataValue={
              Value={ Byte=1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time() - 1,
              ServerTimestamp = os.time(),
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            }
          },
          DataType = ua.NodeIds.DataValue,
          ValueRank = -1,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="datavalue_object_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DataValueArray"},
          Description = {Text="Example of DataValue array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {DataValue={
            {--#1
              Value={ Byte=1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time() - 1,
              ServerTimestamp = os.time(),
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#2
              Value={ SByte=1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time() - 1,
              ServerTimestamp = os.time(),
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#3
              Value={ Int16=1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time() - 1,
              ServerTimestamp = os.time(),
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#4
              Value={ UInt16=1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time() - 1,
              ServerTimestamp = os.time(),
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#5
              Value={ Double=1.1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time(),
              ServerTimestamp = os.time() + 1,
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#6
              Value={ Float=1.1 },
              StatusCode = s.Good,
              SourceTimestamp = os.time(),
              ServerTimestamp = os.time() + 1,
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#7
              Value={ UInt64=122234567789},
              StatusCode = s.Good,
              SourceTimestamp = os.time(),
              ServerTimestamp = os.time() + 1,
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#8
              Value={ String="StringElement"},
              StatusCode = s.Good,
              SourceTimestamp = os.time(),
              ServerTimestamp = os.time() + 1,
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#9
              Value={ StatusCode=s.BadInternalError},
              StatusCode = s.Good,
              SourceTimestamp = os.time(),
              ServerTimestamp = os.time() + 1,
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            },
            {--#10
              Value={ DateTime=os.time()},
              StatusCode = s.Good,
              SourceTimestamp = os.time(),
              ServerTimestamp = os.time() + 1,
              SourcePicoseconds = 100,
              ServerPicoseconds = 200
            }
          }},
          DataType = ua.NodeIds.DataValue,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      }
    }
  }

  Add(client, newVariable)
end


local function Add_DiagnosticInfo_Scalar_And_Array(client, parentNodeId)
  ua.Log.I("Adding DiagnosticInfo scalar and array")

  -- Array with node id attributes of a new DataValue variable
  local newVariable = {
    NodesToAdd = {
      { -- #1
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="disgnosticinfo_object_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DiagnosticInfo"},
          Description = {Text="Example of DiagnosticInfo scalar variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {
            DiagnosticInfo = {
              SymbolicId = -1,
              NamespaceURI = -1,
              Locale = -1,
              LocalizedText = -1,
              AdditionalInfo = "AdditionalInfo",
              InnerStatusCode = s.BadNodeAttributesInvalid,
              InnerDiagnosticInfo = {
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "InnerAdditionalInfo",
                InnerStatusCode = s.BadNodeAttributesInvalid,
              }
            }
          },
          DataType = ua.NodeIds.DiagnosticInfo,
          ValueRank = ua.Types.ValueRank.Scalar,
          ArrayDimensions = nil,
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
      },
      { -- #2
        ParentNodeId = parentNodeId,
        ReferenceTypeId = ua.NodeIds.Organizes,
        RequestedNewNodeId = ua.NodeId.Null,
        BrowseName = {Name="diagnosticinfo_object_array_variable", NamespaceIndex=0},
        NodeClass = ua.Types.NodeClass.Variable,
        NodeAttributes = {
          DisplayName = {Text="DiagnosticInfoArray"},
          Description = {Text="Example of DiagnosticInfo array variable"},
          WriteMask = 0,
          UserWriteMask = 0,
          Value = {
            DiagnosticInfo={
              {--#1
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo1",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo12",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#2
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo2",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo22",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#3
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo3",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo32",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#4
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo4",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo42",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#5
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo5",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo52",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#6
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo6",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo62",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#7
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo7",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo72",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#8
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo8",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo82",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#9
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo9",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo92",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
              {--#10
                SymbolicId = -1,
                NamespaceURI = -1,
                Locale = -1,
                LocalizedText = -1,
                AdditionalInfo = "AdditionalInfo10",
                InnerStatusCode = s.BadNodeAttributesInvalid,
                InnerDiagnosticInfo = {
                  SymbolicId = -1,
                  NamespaceURI = -1,
                  Locale = -1,
                  LocalizedText = -1,
                  AdditionalInfo = "InnerAdditionalInfo102",
                  InnerStatusCode = s.BadNodeAttributesInvalid,
                }
              },
            }
          },
          DataType = ua.NodeIds.DiagnosticInfo,
          ValueRank = ua.Types.ValueRank.OneDimension,
          ArrayDimensions = {10},
          AccessLevel = 0,
          UserAccessLevel = 0,
          MinimumSamplingInterval = 1000,
          Historizing = 0
        },
        TypeDefinition = ua.NodeIds.BaseDataVariableType
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
