// ProductFilters.jsx
import { Accordion, AccordionTab } from 'primereact/accordion'
import { Checkbox } from 'primereact/checkbox'
import {
    layoutSizes,
    connectivities,
    keycapsTypes,
    productTypes
} from '../utils/searchFilters'

const ProductFilters = ({ selectedLayoutSizes, onLayoutChange }) => {
    return (
        <aside className='bg-dark-subtle col-3 p-3' style={{ height: '100vh' }}>
            <h3>Filter Results</h3>

            <Accordion className="mb-4">
                <AccordionTab header="Layout Size">
                    <div className="d-flex row row-gap-2 px-2">
                        {layoutSizes.map((size) => (
                            <div key={size}>
                                <Checkbox
                                    inputId={size}
                                    onChange={() => onLayoutChange(size)}
                                    checked={selectedLayoutSizes.includes(size)}
                                />
                                <label htmlFor={size} className="form-check-label ms-2">
                                    {size}
                                </label>
                            </div>
                        ))}
                    </div>
                </AccordionTab>
            </Accordion>

            <Accordion className="mb-4">
                <AccordionTab header="Connectivities">
                    <div className="d-flex row row-gap-2 px-2">
                        {connectivities.map((c) => (
                            <div key={c}>
                                <Checkbox inputId={c} />
                                <label htmlFor={c} className="form-check-label ms-2">
                                    {c}
                                </label>
                            </div>
                        ))}
                    </div>
                </AccordionTab>
            </Accordion>

            <Accordion className="mb-4">
                <AccordionTab header="Keycaps Types">
                    <div className="d-flex row row-gap-2 px-2">
                        {keycapsTypes.map((type) => (
                            <div key={type}>
                                <Checkbox inputId={type} />
                                <label htmlFor={type} className="form-check-label ms-2">
                                    {type}
                                </label>
                            </div>
                        ))}
                    </div>
                </AccordionTab>
            </Accordion>

            <Accordion className="mb-4">
                <AccordionTab header="Product Types">
                    <div className="d-flex row row-gap-2 px-2">
                        {productTypes.map((type) => (
                            <div key={type}>
                                <Checkbox inputId={type} />
                                <label htmlFor={type} className="form-check-label ms-2">
                                    {type}
                                </label>
                            </div>
                        ))}
                    </div>
                </AccordionTab>
            </Accordion>
        </aside>
    )
}

export default ProductFilters