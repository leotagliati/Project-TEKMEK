import React, { useEffect, useState } from 'react'
import { Accordion, AccordionTab } from 'primereact/accordion'
import { Checkbox } from 'primereact/checkbox'
import {
    layoutSizes,
    connectivities,
    keycapsTypes,
    productTypes
} from '../utils/searchFilters'

const ProductFilters = ({ onChange }) => {
    const [selectedLayoutSizes, setSelectedLayoutSizes] = useState([])
    const [selectedConnectivities, setSelectedConnectivities] = useState([])
    const [selectedKeycaps, setSelectedKeycaps] = useState([])
    const [selectedProductTypes, setSelectedProductTypes] = useState([])

    const toggleSelection = (item, selectedList, setSelectedList) => {
        const updated = selectedList.includes(item)
            ? selectedList.filter((i) => i !== item)
            : [...selectedList, item]

        setSelectedList(updated)
    }

    useEffect(() => {
        onChange({
            layoutSizes: selectedLayoutSizes,
            connectivities: selectedConnectivities,
            keycapsTypes: selectedKeycaps,
            productTypes: selectedProductTypes
        })
    }, [
        selectedLayoutSizes.join(','),
        selectedConnectivities.join(','),
        selectedKeycaps.join(','),
        selectedProductTypes.join(',')
    ])

    return (
        <>
            <div className=" mb-4">

                <h2 className="mb-4">Filters</h2>

                <Accordion className="mb-4">
                    <AccordionTab header="Layout Size">
                        {layoutSizes.map((size) => (
                            <div key={size} className="mb-2 px-2">
                                <Checkbox
                                    inputId={size}
                                    checked={selectedLayoutSizes.includes(size)}
                                    onChange={() => toggleSelection(size, selectedLayoutSizes, setSelectedLayoutSizes)}
                                />
                                <label htmlFor={size} className="form-check-label ms-2">
                                    {size}
                                </label>
                            </div>
                        ))}
                    </AccordionTab>

                    <AccordionTab header="Connectivities">
                        {connectivities.map((c) => (
                            <div key={c} className="mb-2 px-2">
                                <Checkbox
                                    inputId={c}
                                    checked={selectedConnectivities.includes(c)}
                                    onChange={() => toggleSelection(c, selectedConnectivities, setSelectedConnectivities)}
                                />
                                <label htmlFor={c} className="form-check-label ms-2">
                                    {c}
                                </label>
                            </div>
                        ))}
                    </AccordionTab>

                    <AccordionTab header="Keycaps Types">
                        {keycapsTypes.map((k) => (
                            <div key={k} className="mb-2 px-2">
                                <Checkbox
                                    inputId={k}
                                    checked={selectedKeycaps.includes(k)}
                                    onChange={() => toggleSelection(k, selectedKeycaps, setSelectedKeycaps)}
                                />
                                <label htmlFor={k} className="form-check-label ms-2">
                                    {k}
                                </label>
                            </div>
                        ))}
                    </AccordionTab>

                    <AccordionTab header="Product Types">
                        {productTypes.map((p) => (
                            <div key={p} className="mb-2 px-2">
                                <Checkbox
                                    inputId={p}
                                    checked={selectedProductTypes.includes(p)}
                                    onChange={() => toggleSelection(p, selectedProductTypes, setSelectedProductTypes)}
                                />
                                <label htmlFor={p} className="form-check-label ms-2">
                                    {p}
                                </label>
                            </div>
                        ))}
                    </AccordionTab>
                </Accordion>
            </div>
        </>
    )
}

export default ProductFilters
