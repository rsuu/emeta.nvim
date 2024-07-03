-- "◉", "○", "✸", "✿"
local System = {
    entities = {},
    components = { {} },

    ---@class System
    ---@field entities Vec<Entity>
    ---@field components Vec<Map<String, table>>
}

local Entity = {
    id = 0,

    ---@class Entity
    ---@field id integer
}

local Component = {
    type = "",
    data = {},

    ---@class Component
    ---@field type string
    ---@field data table
}

---@return System
System.new = function(self)
    self.__index = self

    return setmetatable({
        entities = {},
        components = {},
    }, self)
end

---@class System
System.register = function(self, entities)
    for _, entity in pairs(entities) do
        table.insert(self.entities, entity)
    end
end

System.insert = function(self, entity, components)
    local id = entity.id

    self.components[id] = {}

    for _, component in pairs(components) do
        self.components[id][component.type] = component.data
    end
end

System.join_all = function(self)
    for _, entity in pairs(self.entities) do
        self:join(entity)
    end
end

System.join = function(self, entity)
    local comps = self.components[entity.id]

    vim.print({ id = entity.id, comps = comps })
end

---@param id integer
---@return Entity
Entity.new = function(self, id)
    self.__index = self

    return setmetatable({ id = id }, self)
end

Component.new = function(self, type, data)
    self.__index = self

    return setmetatable({ type = type, data = data }, self)
end

local test = {
    ecs = function()
        local system = System:new()

        local entity1 = Entity:new(1)
        local entity2 = Entity:new(2)

        system:insert(entity1, {
            Component:new("position", { x = 0, y = 0 }),
            Component:new("age", { age = 20 }),
        })
        system:insert(entity2, {
            Component:new("position", { x = 1, y = 1 }),
            Component:new("age", { age = 30 }),
        })

        system:register({ entity1, entity2 })

        system:join_all()
    end,
}
-- test.ecs()

return { System = System, Entity = Entity, Component = Component }
