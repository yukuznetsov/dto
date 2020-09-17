import React from "react";

const TripView = ({from, to}) => {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="169"
      height="86"
      viewBox="0 0 169 86"
    >
      <defs>
        <filter
          id="filter-1"
          width="140%"
          height="167.7%"
          x="-20%"
          y="-33.8%"
          filterUnits="objectBoundingBox"
        >
          <feOffset
            dy="5"
            in="SourceAlpha"
            result="shadowOffsetOuter1"
          ></feOffset>
          <feGaussianBlur
            in="shadowOffsetOuter1"
            result="shadowBlurOuter1"
            stdDeviation="7.5"
          ></feGaussianBlur>
          <feColorMatrix
            in="shadowBlurOuter1"
            result="shadowMatrixOuter1"
            values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.3 0"
          ></feColorMatrix>
          <feMerge>
            <feMergeNode in="shadowMatrixOuter1"></feMergeNode>
            <feMergeNode in="SourceGraphic"></feMergeNode>
          </feMerge>
        </filter>
      </defs>
      <g fill="none" fillRule="evenodd" stroke="none" strokeWidth="1">
        <g transform="translate(-204 -707)">
          <g transform="translate(130 622)">
            <g filter="url(#filter-1)" transform="translate(67 46)">
              <g transform="translate(23 46)">
                <text
                  fill="#52575A"
                  fontFamily="Helvetica"
                  fontSize="14"
                  fontWeight="normal"
                >
                  <tspan x="18" y="14">
                    {from}
                  </tspan>
                </text>
                <text
                  fill="#52575A"
                  fontFamily="Helvetica"
                  fontSize="14"
                  fontWeight="normal"
                >
                  <tspan x="18" y="60">
                    {to}
                  </tspan>
                </text>
                <g transform="translate(0 5)">
                  <circle
                    cx="4"
                    cy="4"
                    r="5.5"
                    fill="#3A84FF"
                    stroke="#3A84FF"
                    strokeOpacity="0.32"
                    strokeWidth="3"
                  ></circle>
                  <circle
                    cx="4"
                    cy="49"
                    r="5.5"
                    fill="#94979B"
                    stroke="#94979B"
                    strokeOpacity="0.32"
                    strokeWidth="3"
                  ></circle>
                  <path
                    stroke="#DCDDDF"
                    strokeLinecap="square"
                    strokeWidth="2"
                    d="M4 11L4 44"
                  ></path>
                </g>
              </g>
            </g>
          </g>
        </g>
      </g>
    </svg>
  );
}

export default TripView;