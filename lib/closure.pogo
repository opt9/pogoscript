_ = require 'underscore'
codegen utils = require "./codegenUtils"

module.exports (cg) = cg.term {
    constructor (parameters, body, return last statement: true, redefines self: false) =
        self.body = body
        self.is block = true
        self.return last statement = return last statement
        self.parameters = parameters
        self.optional parameters = []
        self.redefines self = redefines self
  
    blockify (parameters, optional parameters) =
        self.parameters = parameters
        self.optional parameters = optional parameters
        self
  
    scopify () =
        if ((self.parameters.length == 0) && (self.optional parameters.length == 0))
            self.cg.scope (self.body.statements)
        else
            self
  
    parameter transforms () =
        if (self._parameter transforms)
            return (self._parameter transforms)

        optionals = optional parameters (
            self.cg
            self.optionalParameters
            self parameter (
                self.cg
                self.redefines self
                block parameters (self)
            )
        )
    
        splat = splat parameters (
            self.cg
            optionals
        )
    
        if (optionals.has optionals && splat.has splat)
            self.cg.errors.add terms (self.optional parameters) with message 'cannot have splat parameters with optional parameters'
    
        self._parameter transforms = splat
  
    transformed statements () =
        self.cg.statements (self.parameterTransforms ().statements ())
  
    transformed parameters () =
        self.parameter transforms ().parameters ()
  
    declare parameters (scope, parameters) =
        for each @(parameter) in (parameters)
            scope.define (parameter.variable name (scope))

    generate java script (buffer, scope) =
        buffer.write ('function(')
        parameters = self.transformed parameters ()
        codegen utils.write to buffer with delimiter (parameters, ',', buffer, scope)
        buffer.write ('){')
        body = self.transformed statements ()
        body scope = scope.sub scope ()
        self.declare parameters (body scope, parameters)

        if (self.return last statement)
            body.generate java script statements return (buffer, bodyScope)
        else
            body.generate java script statements (buffer, body scope)

        buffer.write ('}')
}

block parameters (block) = {
    parameters () =
      block.parameters
    
    statements () =
      block.body.statements
}

optional parameters (cg, optional parameters, next) =
    if (optional parameters.length > 0)
        {
            options = cg.generated variable ['options']
            
            parameters () =
                next.parameters ().concat [self.options]

            statements () =
                optional statements = _.map(optional parameters) @(parm)
                    cg.definition (cg.variable (parm.field, shadow: true), cg.optional (self.options, parm.field, parm.value))
                
                optional statements.concat (next.statements ())
            
            has optionals = true
        }
    else
        next

self parameter (cg, redefines self, next) =
    if (redefines self)
        {
            parameters () =
                next.parameters ()
        
            statements () =
                [cg.definition (cg.self expression (), cg.variable ['this'])].concat (next.statements ())
        }
    else
        next

splat parameters (cg, next) =
    parsed splat parameters = parse splat parameters (cg, next.parameters ())

    {
        parameters () =
            parsed splat parameters.first parameters
    
        statements () =
            splat = parsed splat parameters
            
            if (splat.splat parameter)
                last index = 'arguments.length'
            
                if (splat.last parameters.length > 0)
                    last index = last index + ' - ' + splat.last parameters.length
            
                splat parameter =
                    cg.definition (
                        splat.splat parameter
                        cg.javascript ('Array.prototype.slice.call(arguments, ' + splat.first parameters.length + ', ' + last index + ')')
                    )
            
                last parameter statements = [splat parameter]
                for (n = 0, n < splat.last parameters.length, n = n + 1)
                    param = splat.last parameters.(n)
                    last parameter statements.push (
                        cg.definition (
                            param
                            cg.javascript('arguments[arguments.length - ' + (splat.last parameters.length - n) + ']')
                        )
                    )

                last parameter statements.concat (next.statements ())
            else
                next.statements ()
        
        has splat = parsed splat parameters.splat parameter
    }

parse splat parameters = module.exports.parse splat parameters (cg, parameters) =
    first parameters = take from (parameters) while @(param)
        !param.is splat
    
    maybe splat = parameters.(first parameters.length)
    splat param = nil
    last parameters = nil
    
    if (maybe splat && maybe splat.is splat)
        splat param = first parameters.pop ()
        splat param.shadow = true
        last parameters = parameters.slice (first parameters.length + 2)
        
        last parameters = _.filter(last parameters) @(param)
            if (param.is splat)
                cg.errors.add term (param) with message 'cannot have more than one splat parameter'
                false
            else
                true
    else
        last parameters = []
    
    {
        first parameters = first parameters
        splat parameter = splat param
        last parameters = last parameters
    }

take from (list) while (can take) =
    taken list = []
    
    for each @(item) in (list)
        if (can take (item))
            taken list.push (item)
        else
            return (taken list)

    taken list