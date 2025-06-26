-- This Lua filter adds the Quarto version as an expansion of <?quarto.version?>.
-- Taken from the Quarto Blog template

local function ensure_pandoc_api_version()
  if PANDOC_VERSION == nil then
    -- if pandoc_version < 2.17 (earlier versions don't have PANDOC_VERSION)
    -- we still want this filter to work
    PANDOC_VERSION = {2, 17, 0}
  end
end

function Meta(meta)
  ensure_pandoc_api_version()
  local quarto = meta.quarto
  if quarto ~= nil then
    quarto.version = quarto.version or ""
  end
  return meta
end

function Str(el)
  if el.text == "<?quarto.version?>" then
    local quarto_version = "1.3.0"
    -- if we have a higher pandoc version, we can use the dynamic lookup
    if PANDOC_VERSION[1] > 2 or (PANDOC_VERSION[1] == 2 and PANDOC_VERSION[2] >= 17) then
      local meta = quarto.doc.meta
      if meta.quarto ~= nil then
        quarto_version = meta.quarto.version
      end
    end
    return pandoc.Str(quarto_version)
  else
    return el
  end
end